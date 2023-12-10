clear;clc
load gangcai2.mat


%%  �ж��Ƿ���Ҫ����
[n,m] = size(X);
disp(['����' num2str(n) '�����۶���, ' num2str(m) '������ָ��']) 
Judge = input(['��' num2str(m) '��ָ���Ƿ���Ҫ�������򻯴�����Ҫ������1 ������Ҫ����0��  ']);

if Judge == 1
    Position = input('��������Ҫ���򻯴����ָ�����ڵ��У������2��3��6������Ҫ������ô����Ҫ����[2,3,6]�� '); %[2,3,4]
    disp('��������Ҫ�������Щ�е�ָ�����ͣ�1����С�ͣ� 2���м��ͣ� 3�������ͣ� ')
    Type = input('���磺��2���Ǽ�С�ͣ���3���������ͣ���6�����м��ͣ�������[1,3,2]��  '); %[2,1,3]

    
    for i = 1 : size(Position,2) 
        X(:,Position(i)) = Positivization(X(:,Position(i)),Type(i),Position(i));
    end
    disp('���򻯺�ľ��� X =  ')
    disp(X)
end

%% �ж��Ƿ���Ҫ����Ȩ��
disp('�������Ƿ���Ҫ����Ȩ����������Ҫ����1������Ҫ����0')
Judge = input('�������Ƿ���Ҫ����Ȩ�أ� ');
if Judge == 1
    disp(['�������3��ָ�꣬�����Ҫ����3��Ȩ�أ��������Ƿֱ�Ϊ0.25,0.25,0.5, ������Ҫ����[0.25,0.25,0.5]']);
    weigh = input(['����Ҫ����' num2str(m) '��Ȩ����' '��������������ʽ������' num2str(m) '��Ȩ��: ']);
    OK = 0; 
    while OK == 0 
        if abs(sum(weigh) - 1)<0.000001 && size(weigh,1) == 1 && size(weigh,2) == m   % ����Ҫע�⸡�����������ǲ���׼�ġ�
             OK =1;
        else
            weigh = input('���������������������Ȩ��������: ');
        end
    end
else
    weigh = ones(1,m) ./ m ; 
end


%% �����򻯺�ľ�����б�׼��
Z = X ./ repmat(sum(X.*X) .^ 0.5, n, 1);
disp('��׼������ Z = ')
disp(Z)

%% ���������ֵ�ľ������Сֵ�ľ��룬������÷�
D_P = sum([(Z - repmat(max(Z),n,1)) .^ 2 ] .* repmat(weigh,n,1) ,2) .^ 0.5;   % D+ �����ֵ�ľ�������
D_N = sum([(Z - repmat(min(Z),n,1)) .^ 2 ] .* repmat(weigh,n,1) ,2) .^ 0.5;   % D- ����Сֵ�ľ�������
S = D_N ./ (D_P+D_N);    % δ��һ���ĵ÷�
disp('���ĵ÷�Ϊ��')
stand_S = S / sum(S)
[sorted_S,index] = sort(stand_S ,'descend')