function Psorout = PSO_TSP(xy,dmat,Popsize,IterNum,showProg,showResult)
%��������Ⱥ�Ż��㷨���TSP����
nargs = 6;%������Ҫ��������ĸ���
 
for i = nargin:nargs-1
    switch i
        case 0  %������������
            xy = [488,814;1393,595;2735,2492;4788,4799;4825,1702;789,2927;4853,1120;4786,3757;2427,1276;4002,2530;710,3496;2109,4455;4579,4797;3962,2737;4798,694;3279,747;179,1288;4246,4204;4670,1272;3394,4072;3789,1218;3716,4647;
                1962,1750];
%            xy = 5000*rand(39,2);%����40����������40*2����
        case 1  %����������
            N = size(xy,1);
            a = meshgrid(1:N);%����N*N�������
            dmat = reshape(sqrt(sum((xy(a,:)-xy(a',:)).^2,2)),N,N);% 'Ϊ�����ת�ã�reshape����������N*N�ľ���
        case 2  %��������Ⱥ��Ŀ
            Popsize = 500;
        case 3  %���õ�������
            IterNum = 2000;
        case 4  %�Ƿ�չʾ��������
            showProg = 1;
        case 5  %�Ƿ�չʾ���
            showResult = 1;
        otherwise
    end
end
%������������м��
[N,~] = size(xy);%���и�����ά��
[nr,nc] = size(dmat);%������������������
if N~=nr || N~=nc
    error('�����������������������')
end
showProg = logical(showProg(1));%����ֵת��Ϊ�߼�ֵ
showResult = logical(showResult(1));
%��������λ�÷ֲ�ͼ
figure(1);
plot (xy(:,1),xy(:,2),'k.','MarkerSize',14);
title('��������λ��');
 
%% PSO������ʼ��
c1 = 0.1;                   %����ѧϰ����
c2 = 0.075;                 %���ѧϰ����
w = 1;                      %��������
pop = zeros(Popsize,N);     %����λ��
v = zeros(Popsize,N);       %�����ٶ�
iter = 1;                   %����������ʱ
fitness = zeros(Popsize,1); %��Ӧ�Ⱥ���ֵ
Pbest = zeros(Popsize,N);   %���弫ֵ·��
Pbest_fitness = zeros(Popsize,1);   %���弫ֵ
Gbest = zeros(IterNum,N);            %Ⱥ�弫ֵ·��
Gbest_fitness = zeros(Popsize,1);     %Ⱥ�弫ֵ
Length_ave = zeros(IterNum,1);
ws = 1;                                %�����������ֵ
we = 0.5;                               %����������Сֵ
 
%% ������ʼλ�ú��ٶ�
for i = 1:Popsize
    pop(i,:) = randperm(N);
    v(i,:) = randperm(N);
end
%����������Ӧ��ֵ
for i =1:Popsize
    for j =1:N-1
        fitness(i) = fitness(i) + dmat(pop(i,j),pop(i,j+1));
    end
    fitness(i) = fitness(i) + dmat(pop(i,end),pop(i,1));%�����յ�ص����ľ���
end
%������弫ֵ��Ⱥ�弫ֵ
Pbest_fitness = fitness;
Pbest = pop;
[Gbest_fitness(1),min_index] = min(fitness);
Gbest(1,:) = pop(min_index);
Length_ave(1) = mean(fitness);
 
%% ����Ѱ��
while iter <IterNum
    %���µ������������ϵ��
    iter = iter +1;
    w = ws-(ws-we)*(iter/IterNum)^2;%��̬����ϵ��
    %�����ٶ�
    %���弫ֵ���н�������
    change1 = positionChange(Pbest,pop);
    change1 = changeVelocity(c1,change1);%�Ƿ���н���
    %Ⱥ�弫ֵ���н�������
    change2 = positionChange(repmat(Gbest(iter-1,:),Popsize,1),pop);%��Gbest���Ƴ�m��
    change2 = changeVelocity(c2,change2);
    %ԭ�ٶȲ���
    v = OVelocity(w,v);
    %�����ٶ�
    for i = 1:Popsize
        for j =1:N
            if change1(i,j) ~= 0
                v(i,j) = change1(i,j);
            end
            if change2(i,j) ~= 0
                v(i,j) = change2(i,j);
            end
        end
    end
    %��������λ��
    pop = updatePosition(pop,v);%�������ӵ�λ�ã�Ҳ���Ǹ���·������
    %��Ӧ��ֵ����
    fitness = zeros(Popsize,1);
    for i = 1:Popsize
        for j = 1:N-1
            fitness(i) = fitness(i) + dmat(pop(i,j),pop(i,j+1));
        end
        fitness(i) = fitness(i) + dmat(pop(i,end),pop(i,1));
    end
    
    %���弫ֵ��Ⱥ�弫ֵ�ĸ���
    for i =1:Popsize
        if fitness(i) < Pbest_fitness(i)
            Pbest_fitness(i) = fitness(i);
            Pbest(i,:) = pop(i,:);
        end
    end
    [minvalue,min_index] = min(fitness);
    if minvalue <Gbest_fitness(iter-1)
        Gbest_fitness(iter) = minvalue;
        Gbest(iter,:) = pop(min_index,:);
        if showProg
            figure(2);
            for i = 1:N-1 %�����м��
                plot([xy(Gbest(iter,i),1),xy(Gbest(iter,i+1),1)],[xy(Gbest(iter,i),2),xy(Gbest(iter,i+1),2)],'bo-','LineWidth',2);
                hold on;
            end
            plot([xy(Gbest(iter,end),1),xy(Gbest(iter,1),1)],[xy(Gbest(iter,end),2),xy(Gbest(iter,1),2)],'bo-','LineWidth',2);
            title(sprintf('����·�߾��� = %1.2f���������� = %d��',minvalue,iter));
            hold off
        end 
    else
        Gbest_fitness(iter) = Gbest_fitness(iter-1);
        Gbest(iter,:) = Gbest(iter-1,:);
    end
    Length_ave(iter) = mean(fitness);
end
%% �����ʾ
[Shortest_Length,index] = min(Gbest_fitness);
BestRoute = Gbest(index,:);
if showResult
   figure(3);
   plot([xy(BestRoute,1);xy(BestRoute(1),1)],[xy(BestRoute,2);xy(BestRoute(1),2)],'o-')
   grid on
   xlabel('����λ�ú�����');
   ylabel('����λ��������');
   title(sprintf('����Ⱥ�㷨�Ż�·����̾��룺%1.2f',Shortest_Length));
   figure(4);
   plot(1:IterNum,Gbest_fitness,'b',1:IterNum,Length_ave,'r:')
   legend('��̾���','ƽ������');
   xlabel('��������');
   ylabel('����')
   title('������̾�����ƽ������Ա�');
end
if nargout
    Psorout{1} = BestRoute;
    Psorout{2} = Shortest_Length; 
end     
end
 
function change = positionChange(best,pop)
%��¼��pop���best�Ľ�������
for i = 1:size(best,1)
    for j =1:size(best,2)
        change(i,j) = find(pop(i,:)==best(i,j));%������i���ҵ�best(i,j)λ������
        temp = pop(i,j);%�����н���
        pop(i,j) = pop(i,change(i,j));
        pop(i,change(i,j)) = temp;
    end
end
end
function change = changeVelocity(c,change)
%��һ���ĸ��ʱ�������
for i =1:size(change,1)
    for j = 1:size(change,2)
        if rand > c
            change(i,j) = 0;
        end
    end
end
end
function v = OVelocity(c,v)
%��һ���ĸ��ʱ�����һ�ε����Ľ�������
for i =1:size(v,1)
    for j = 1:size(v,2)
        if rand >c
            v(i,j) = 0;
        end
    end
end
end
function pop = updatePosition(pop,v)
%�����ٶȼ�¼�Ľ������н���λ�õĸ���
for i = 1:size(pop,1)
    for j =1:size(pop,2)
        if v(i,j) ~= 0
            temp = pop(i,j);
            pop(i,j) = pop(i,v(i,j));
            pop(i,v(i,j)) = temp;
        end
    end
end
end