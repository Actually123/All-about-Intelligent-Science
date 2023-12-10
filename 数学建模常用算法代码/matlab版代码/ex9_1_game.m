clear;clc;
n=900;%����������
min_price=170;%����۸�Χ
max_price=230;
A=normrnd(36,5,1,25);%��ʼ������ƽ��ֵΪ36������Ϊ5�ĸ�˹�ֲ�
E=fix(A); %��0����ȡ�����磬4.1��4.5��4.8ȡ������4
%�����Ǹ�������������E�Ĵ�С
a=sum(E)-n;
A=A-a/25;
E=fix(A);
b=sum(E)-n;
A=A-b/25;
E=fix(A);
a1=0.05;a2=0.95;%����ɱ��뻻��۸�Ȩ��
x=rand(n,1).*20000;%��ʼ��������λ��
y=rand(n,1).*20000;
H=[2,2;2,6;2,10;2,14;2,18%��ʼ������վλ��
6,2;6,6;6,10;6,14;6,18
10,2;10,6;10,10;10,14;10,18
14,2;14,6;14,10;14,14;14,18
18,2;18,6;18,10;18,14;18,18].*1000;
%���Ƴ�ʼ����˾���뻻��վ��λ��ͼ
figure
plot(x,y,'r*')
hold on
plot(H(:,1),H(:,2),'bo')
legend('˾��','����վ')
title('��ʼλ��ͼ')
 
%% ����������ʵ������
D=[];%��������������վ���������
price=200.*ones(1,25);
for i=1:length(H)
    for j=1:length(x)
            D(i,j)=a1*sqrt((H(i,1)-x(j))^2+(H(i,2)-y(j))^2)+a2*price(i);%�ܷ���
    end
end
[d1,d2]=min(D);%ѡ��������뻻��վ
C=tabulate(d2(:));%ͳ��ѡ�񻻵�վ����
e=C(:,2);
err=sum(abs(E-e')); %������֮�ͣ������Ķ���
% ER(1)=err
%% ����
J=[]; %�۸�仯�Ĳ�ֵ
ER(1)=err;
for k=2:100
    j=0;
    for i=1:25
        if e(i)<E(i) && price(i)>=min_price
            price(i)=price(i)-1;
            j=j+1;
        end
        if e(i)>E(i) && price(i)<=max_price
            price(i)=price(i)+1;
            j=j+1;
        end
    end
    J=[J,j];
    DD=[];
    for i=1:length(H)
        for j=1:length(x)
            DD(i,j)=a1*sqrt((H(i,1)-x(j))^2+(H(i,2)-y(j))^2)+a2*price(i);
        end
    end
    [dd1,dd2]=min(DD);
    CC=tabulate(dd2(:));
    e=CC(:,2);
    err=sum(abs(E-e'));
    ER=[ER,err];
end
% ��ͼ
figure
plot(ER,'-o')
title('E-e�Ĳ�ֵ�仯')
set(gcf,'unit','normalized','position',[0.2,0.2,0.64,0.32])
legend('E-e')
 
figure
plot(J,'r-o')
title('�۸�Ĳ�ֵ�仯')
xlabel('Iterations(t)')
set(gcf,'unit','normalized','position',[0.2,0.2,0.64,0.32])
legend('sum of Price(t)-Price(t-1)')
 
figure
bar(price,0.5)
hold on
plot([0,26],[min_price,min_price],'g--')
plot([0,26],[max_price,max_price],'r--')
title('����վ�Ļ���۸�')
ylabel('Price(��)')
axis([0,26,0,300])
set(gcf,'unit','normalized','position',[0.2,0.2,0.64,0.32]);
 
figure
h=bar([e,E'],'gr');
set(h(1),'FaceColor','g'); set(h(2),'FaceColor','r');
axis([0,26,0,50])
title('���⳵��Ԥ�ں�ʵ������')
ylabel('E and e')
set(gcf,'unit','normalized','position',[0.2,0.2,0.64,0.32]);
xlabel('����վ')
legend('e','E')