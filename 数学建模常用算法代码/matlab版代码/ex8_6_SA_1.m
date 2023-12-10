clear
close all
clc

D = 10;
X_Min = -20;
X_Max = 20;
L = 500; % ÿһ���¶��µĵ�������
alpha = 0.998; % T_Next = T_Current*h
S0 = 10; % ��������
T0 = 10000; % ��ʼ�¶�
T = T0;
error_Thre = 1e-8; % ���ۺ�����ֵ
T_Thre = 0.001;
K = 0.6; % Metropolis׼��ϵ��

% ����������ʼ��
iter = 1;
iter_Max = log(T_Thre/T0)/log(alpha);
% iter_Max = T0/T_Thre;


% ������ʼ��
Current_X = rand(1, D) .* (X_Max - X_Min) + X_Min;
Current_X_Fitness = Fitness(Current_X);
Pre_X = Current_X;
Pre_X_Fitness = Current_X_Fitness;
Best_X = Current_X;
MinFitness_List = zeros(1,floor(iter_Max)+100);
MinFitness_List(1) = Fitness(Best_X);
Fitness_List = zeros(1,floor(iter_Max)+100);
Fitness_List(1) = MinFitness_List(1);

% ��������йصĶ���
waitbarinter = iter_Max/100;   
tic
h = waitbar(0, ['�����:0%   ������...��ʱ:', num2str(toc)]);

while (MinFitness_List(iter) > error_Thre) && (T > T_Thre)
    iter = iter+1;
    % 1.����ģ���˻�
    T = alpha * T;
    % % 2. ����ģ���˻�
    % T = T0/log10(iter);
    % % 3. ����ģ���˻�
    % T = T0/(iter);


    % �ڵ�ǰ�¶�T�µĵ���
    % ��ǰ�¶������Ž�ĳ�ʼ��
    Fitness_temp = 0;
    X_temp = zeros(1,D);
    for i = 1:L
        % ��������µĽ�
        N_temp = randn(1,D);
        P_temp = N_temp/sqrt(sum(N_temp.^2));
        Current_X = Pre_X + T*P_temp;
        % �߽�����    ��ֹ�������С
        Current_X = BoundaryLimit(Current_X, X_Min, X_Max);
        Current_X_Fitness = Fitness(Current_X);
        % ���µ�ǰ�¶��µ����Ž�
        if i == 1
            Fitness_temp = Current_X_Fitness;
            X_temp = Current_X;
        else
            if Current_X_Fitness < Fitness_temp
                Fitness_temp = Current_X_Fitness;
                X_temp = Current_X;
            end
        end
        % �жϵ�ǰ�������Ž��Լ���һ��Ĵ�С��ϵ
        if Pre_X_Fitness <= Current_X_Fitness
            % ��ǰ�ⲻ����һ�ν�   Metropolis׼�򣬼�С�ֲ����Ž�Ŀ���
            P = exp(-1 * (Current_X_Fitness - Pre_X_Fitness) / K / T);
            if P > rand
                Pre_X = Current_X;
                Pre_X_Fitness = Current_X_Fitness;
            end

            % ��ǰ�����һ�ν��
        else
            Pre_X = Current_X;
            Pre_X_Fitness = Current_X_Fitness;
        end
    end

    % ����ȫ�����Ž�
    if MinFitness_List(iter-1) > Fitness_temp
        MinFitness_List(iter) = Fitness_temp;
        Best_X = X_temp;
    else
        MinFitness_List(iter) = MinFitness_List(iter-1);
    end
    % ��ÿ���¶��µ����Žⶼ�洢����
    Fitness_List(iter) = Fitness_temp;
    % ������
    if mod(iter, waitbarinter) <1
        waitbar(iter / iter_Max, h, ['�����:' num2str(iter / iter_Max * 100) ...
        '%   ������...��ʱ:', num2str(toc),'/',num2str(toc/iter * iter_Max)])
    end
end
close(h)

% �������չʾ
display(['The best solution obtained by SA is : ', num2str(Best_X)]);
display(['The best optimal value of the objective funciton found by SA is : ', num2str(MinFitness_List(iter))]);

% ���ͼ��չʾ
figure
semilogy(MinFitness_List(1:iter),'linewidth',1.2)
hold on
semilogy(Fitness_List(1:iter),'linewidth',1.2)
legend(['��С��Ӧ�ȱ仯'],['��Ӧ�ȱ仯'])
title('Convergence Curve')
xlabel('Iteration');
ylabel('Best score obtained so far');
axis tight
grid on
box on


% Ŀ�꺯��
function result = Fitness(x)
    result = sum(x.^2);
end

% �߽����ƺ���
function result = BoundaryLimit(X, Min, Max)

    for i_temp = 1:length(X)

        if X(i_temp) > Max
            X(i_temp) = Max;
        end

        if X(i_temp) < Min
            X(i_temp) = Min;
        end

    end

    result = X;
end

