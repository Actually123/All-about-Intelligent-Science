clc;clear;
%��ȡ����
data=xlsread('huiseguanlian.xlsx');
%���ݱ�׼��
data1=mapminmax(data',0,1); %��׼����0-1����
data1=data1';
%%���� x1,x4,x5,x6,x7 ������ͼ
figure(1)
t=[2007:2013];
plot(t,data1(:,1),'LineWidth',2)
hold on 
for i=1:4
    plot(t,data1(:,3+i),'--')
    hold on
end
xlabel('year')
legend('x1','x4','x5','x6','x7')
title('��ɫ��������')
 
%%�����ɫ���ϵ��
%�õ������кͲο�����ȵľ���ֵ
for i=4:7
    data1(:,i)=abs(data1(:,i)-data1(:,1));
end
 
%�õ�����ֵ�����ȫ�����ֵ����Сֵ
data2=data1(:,4:7);
d_max=max(max(data2));
d_min=min(min(data2));
%��ɫ��������
a=0.5;   %�ֱ�ϵ��
data3=(d_min+a*d_max)./(data2+a*d_max);
xishu=mean(data3);
disp(' x4,x5,x6,x7 �� x1֮��Ļ�ɫ�����ȷֱ�Ϊ��')
disp(xishu)