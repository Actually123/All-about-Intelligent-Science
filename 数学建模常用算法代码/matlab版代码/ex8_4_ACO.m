%% ����
clear, clc;
%% ��������
citys = [116.46 39.92
          117.2 39.13
          121.48 31.22
          106.54 29.59
          91.11 29.97
          87.68 43.77
          106.27 38.47
          111.65 40.82
          108.33 22.84
          126.63 45.75
          125.35 43.88
          123.38 41.8
          114.48 38.03
          112.53 37.87
          101.74 36.56
          117 36.65
          113.6 34.76
          118.78 32.04
          117.27 31.86
          120.19 30.26
          119.3 26.08
          115.89 28.68
          113 28.21
          114.31 30.52
          113.23 23.16
          121.5 25.05
          110.35 20.02
          103.73 36.03
          108.95 34.27
          104.06 30.67
          106.71 26.57
          102.73 25.04
          114.1 22.2
          113.33 22.13];
 %% ����������
 D = Distance2(citys);   %����������
 n = size(D, 1);         %������и���
 %% ��ʼ������
 NC_max = 3000;         %�㷨����������
 NC = 1;                %�㷨��ʼ��������
 m = 35;                %���ϵ���Ŀ
 alpha = 1;             %��Ϣ����Ҫ�̶�����
 beta = 4;              %����������Ҫ�̶�����
 rho = 0.2;             %��Ϣ�ػӷ��̶�
 Q = 20;         %��������ʾ����ѭ��һ�����ͷŵ���Ϣ������
 Eta = 1 ./ D;   %������������ʾ���ϴӳ���iת�Ƶ�����j�������̶�
 Tau = ones(n, n); %Tau(i, j)��ʾ��(i, j)����Ϣ��������ʼ����Ϊ1
 Table = zeros(m, n);   %mֻ���ϵľ���n�����е�·����¼��
 rBest = zeros(NC_max, n);         %��¼���������·��
 lBest = inf .* ones(NC_max, 1);   %��¼���������·�ߵ��ܳ��ȣ���ʼ��Ϊ������
 lAverage = zeros(NC_max, 1);      %��¼����·�ߵ�ƽ������
 %% �㷨���岿�֣�����Ѱ������·��
 while NC <= NC_max
     % ����������������ϵ�������
     start = zeros(m, 1);        
     for i = 1:m
         temp = randperm(n);     %����n�����ظ�������
         start(i) = temp(1);     %��temp�е�һ������Ϊ����i��������
     end
     Table(:, 1) = start;        %Table��ĵ�һ�м����������ϵ�������
     citys_index = 1: n;         %���г��������ļ���
     
     % �ڹ����ռ�    
     for i = 1:m                 %������Ͻ���·��ѡ��
         for j = 2:n             %�������·��ѡ��(���������⣬ʣ�� n - 1 �����д�����)
             tabu = Table(i, 1:(j - 1));  %����i�ѷ��ʵĳ��м��ϣ�Ҳ��Ϊ���ɱ�
             allow_index = ~ismember(citys_index, tabu); %����ismember(a,b)�����ж�a��Ԫ���Ƿ���b��Ԫ����ͬ����ͬ����1
             Allow = citys_index(allow_index);               %Allow�����ڴ�����ϴ����ʵĳ��м���(���б��)
             P = Allow;
             
            %�������ϴӳ��У�j - 1����ʣ��δ���ʵĳ��е�ת�Ƹ���
             for k = 1:size(Allow, 2)
                 P(k) = Tau(tabu(end), Allow(k))^alpha * Eta(tabu(end), Allow(k))^beta;  %����ת�Ƹ��ʹ�ʽ�ķ��Ӳ���
             end                                   %tabu(end)��ʾ���ϵ�ǰ���ڳ���j��Allow(k)��ʾ����δ���ʵĵ�k������
             P = P / sum(P);        %����ת�Ƹ��ʹ�ʽ��sum(P)��ʾת�Ƹ��ʹ�ʽ�ķ�ĸ����
             
             %�������̶ķ�ѡ����һ�����ʵĳ���(���������)
             Pc = cumsum(P, 2);   %���а����ۼ�
             target_index = find(Pc >= rand);  %�ҵ�Ŀ����е���������
             target = Allow(target_index(1));  %ѡ���������ϵĵ�һ��������Ϊ������һ�����ʵĳ���
             Table(i, j) = target;   %ȷ������i�ѷ��ʵĵ�j������
         end
     end
     
     % �ۼ���������ϵ�·������
     length = zeros(m, 1);
     for i = 1:m
         Route = Table(i,: ); %Route�������i������·��
         for j = 1:(n - 1)
             length(i) = length(i) + D(Route(j), Route(j + 1));
         end
         length(i) = length(i) + D(Route(n), Route(1)); % ��������i���һ�����е���һ�����е�·������
     end
     
     % �ܼ������·�����뼰ƽ������
     if NC == 1
        [min_Length, min_index] = min(length);   %min_index���ص������·�������ϱ��
        lBest(NC) = min_Length;
        lAverage(NC) = mean(length);
        rBest(NC, :) = Table(min_index, :);
     else
        [min_Length, min_index] = min(length);
        lBest(NC) = min(lBest(NC - 1), min_Length);  %�Ƚ���һ��������ֵ�ͱ���������ֵ
        lAverage(NC) = mean(length);
        if lBest(NC) == min_Length
            rBest(NC, :) = Table(min_index, :);      %��¼����·��
        else
            rBest(NC, :) = rBest((NC - 1), :);       
        end
     end
     
    % �ݸ�����Ϣ��
    Delta_tau = zeros(n, n);   %���������ڳ���i������j����·�����ͷŵ���Ϣ��Ũ��֮��
    for i = 1: m               %������ϼ���
        for j = 1: (n - 1)     %������м���
            Delta_tau(Table(i, j), Table(i, j + 1)) = Delta_tau(Table(i, j), Table(i, j + 1)) + Q / length(i);
        end
        Delta_tau(Table(i, n), Table(i, 1)) = Delta_tau(Table(i, n), Table(i, 1)) + Q / length(i);
    end
    Tau = (1 - rho) .* Tau + Delta_tau;
    
     % �޵���������1�����·����¼��
    NC = NC + 1;
    Table = zeros(m, n);
 end

%% �����ʾ
[shortest_Length, shortest_index] = min(lBest);
shortest_Route = rBest(shortest_index, :);
disp(['��̾���:' num2str(shortest_Length)])
disp(['���·��:' num2str([shortest_Route shortest_Route(1)])])
     
%% ��ͼ
figure(1)
plot([citys(shortest_Route,1); citys(shortest_Route(1),1)],...
     [citys(shortest_Route,2); citys(shortest_Route(1),2)],'o-');
grid on
for i = 1: size(citys, 1)
    text(citys(i, 1), citys(i, 2), ['   ' num2str(i)]);
end
text(citys(shortest_Route(1), 1), citys(shortest_Route(1), 2), '       ���');
text(citys(shortest_Route(end), 1), citys(shortest_Route(end), 2), '       �յ�');
xlabel('����')
ylabel('γ��')
title(['��Ⱥ�㷨�Ż�·��(��̾���: ' num2str(shortest_Length) ')'])
figure(2)
plot(1: NC_max, lBest, 'b', 1: NC_max, lAverage, 'r:')
legend('��̾���', 'ƽ������')
xlabel('��������')
ylabel('����')
title('������̾�����ƽ������Ա�')
            

