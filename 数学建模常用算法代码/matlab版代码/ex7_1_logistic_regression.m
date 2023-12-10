%% ����׼��
% x_{i} \in {1 \times d} һ������
% y_{i} \in {0,1}
% ������ ����������ݡ�  200������  ÿ������2������
% �����ǵ������У�һ�б�ʾһ������
data=1*rand(300,2);
label=zeros(300,1);
 
label((data(:,2)>1+data(:,1)>1))=1;
%��data�ϼӳ��������
data=[data,ones(size(data,1),1)];
 
%����˳��
randIndex = randperm(size(data,1));
data_new=data(randIndex,:);
label_new=label(randIndex,:);
 
%80%ѵ��  20%����
k=0.8*size(data,1);
X=data_new(1:k,:);
Y=label_new(1:k,:);
tstX=data_new(k+1:end,:);
tstY=label_new(k+1:end,:);
 

max_iter = 300;
%% ���ú���
[loss,acc,pre_Y] = logistic_regression(X,Y,tstX,tstY,max_iter);
acc
% ��������������ʧ����ֵ�ı仯
plot(loss(2:end))

function [loss,acc,pre_Y] = logistic_regression(X,Y,tstX,tstY,max_iter)
%% �ݶ��½���
iter = 1;
epsilon = 1e-5;
loss = zeros(max_iter,1);
alpha = 1; % ѧϰ��Ϊ1
[m,d] = size(X);
theta = rand(d,1); % ��ʼ��
while iter < max_iter
    % �����ݶ�
    % �����д�ɾ������ʽ
    h = 1./(1+exp(-X*theta)); % h(\theta)
    item1 = repmat(h,1,d); 
    item2 = repmat(Y,1,d);
    g = sum(X.*(item1-item2))/m;  
    g = g'; % �ݶ�    
    
    theta = theta-alpha*g;
    
    iter = iter+1;
    loss(iter) = -(Y'*log(h)+(1-Y')*log(1-h))/m; % ���㽻������ʧ
    
    if norm(loss(iter)-loss(iter-1)) < epsilon
        break;
    end
end
%% Ԥ��
tmp = tstX*theta;
p1 = 1./(1+exp(-tmp));
% Ԥ��ֵ
pre_Y = p1>0.5; % ����0.5��ʾ����
% ����
acc = sum(pre_Y==tstY)/length(tstY)*100;
end