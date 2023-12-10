clear;clc;
% ��������
vertexs=importdata('city.txt');          %��������
n=length(vertexs);                        %������Ŀ
dist=zeros(n);                            %���о������
for i = 1:n
    for j = 1:n
        dist(i,j)=distance(vertexs(i,:),vertexs(j,:));
    end
end
% �Ŵ��㷨��������
NIND=50;                        %��Ⱥ��С
MAXGEN=150;                     %��������
Pm=0.9;                         %�������
Pc=0.1;                         %�������
pSwap=0.2;                      %ѡ�񽻻��ṹ�ĸ���
pReversion=0.5;                 %ѡ����ת�ṹ�ĸ���
pInsertion=0.3;                 %ѡ�����ṹ�ĸ���
N=n;                            %Ⱦɫ�峤��=������Ŀ
% ��Ⱥ��ʼ��
Chrom=InitPop(NIND,N);
% �Ż�
gen=1;                          %������
bestChrom=Chrom(1,:);           %��ʼȫ�����Ÿ���
bestL=RouteLength(bestChrom,dist);%��ʼȫ�����Ÿ�����ܾ���
BestChrom=zeros(MAXGEN,N);      %��¼ÿ�ε���������ȫ�����Ÿ���
BestL=zeros(MAXGEN,1);          %��¼ÿ�ε���������ȫ�����Ÿ�����ܾ���
while gen<=MAXGEN
    SelCh=BinaryTourment_Select(Chrom,dist);            %��Ԫ������ѡ��          
    SelCh=Recombin(SelCh,Pm);                           %OX����
    SelCh=Mutate(SelCh,Pc,pSwap,pReversion,pInsertion); %����
    Chrom=SelCh;                                        %��Chrom����ΪSelCh
    Obj=ObjFunction(Chrom,dist);                        %���㵱ǰ�����и����ܾ���
    [minObj,minIndex]=min(Obj);                         %�ҳ���ǰ�������Ÿ���
    if minObj<=bestL                                    %����ǰ�������Ÿ�����ȫ�����Ÿ�����бȽϣ������ǰ�����Ÿ�����ã���ȫ�����Ÿ�������滻
        bestChrom=Chrom(minIndex,:); 
        bestL=minObj;
    end
    BestChrom(gen,:)=bestChrom;                         %��¼ÿһ��ȫ�����Ÿ��壬�����ܾ���
    BestL(gen,:)=bestL;
    disp(['��' num2str(gen) '�ε�����ȫ������·���ܾ��� = ' num2str(bestL)]); %��ʾ���ѭ��ÿ�ε�������ȫ������·�ߵ��ܾ���
    figure(1);                                          %����ÿ�ε�����ȫ������·��ͼ
    PlotRoute(bestChrom,vertexs(:,1),vertexs(:,2))
    pause(0.01);
    gen=gen+1;    %��������1
end
figure;                                                 % ��ӡÿ�ε�����ȫ�����Ÿ�����ܾ���仯����ͼ
plot(BestL,'LineWidth',1);
title('�Ż�����')
xlabel('��������');
ylabel('�ܾ���');

function dist = distance(a,b)
%a          ��һ����������
%b          �ڶ�����������
%dist       ��������֮�����
    x = (a(1)-b(1))^2;
    y = (a(2)-b(2))^2;
    dist = (x+y)^(1/2);
end

function Dist=ObjFunction(Chrom,dist)
%Chrom           ��Ⱥ
%dist            �������
%Dist            ÿ�������Ŀ�꺯��ֵ����ÿ��������ܾ���
    NIND=size(Chrom,1);                     %��Ⱥ��С
    Dist=zeros(NIND,1);                      %Ŀ�꺯����ʼ��Ϊ0
    for i=1:NIND
        route=Chrom(i,:);                   %��ǰ����
        Dist(i,1)=RouteLength(route,dist);   %���㵱ǰ������ܾ���
    end
end

function L=RouteLength(route,dist)
%route               ·��
%dist                �������
%L                   ��·���ܾ���
    n=length(route);
    route=[route route(1)];
    L=0;
    for k=1:n 
        i=route(k);
        j=route(k+1); 
        L=L+dist(i,j); 
    end
end

function Chrom=InitPop(NIND,N)
%��Ⱥ��ʼ��
%NIND        ��Ⱥ��С
%N           Ⱦɫ�峤��
%Chrom       ������ɵĳ�ʼ��Ⱥ
    Chrom=zeros(NIND,N);                %��Ⱥ��ʼ��ΪNIND��N�е������
    for i=1:NIND
        Chrom(i,:)=randperm(N);         %ÿ������Ϊ1~N���������
    end
end

function FitnV=Fitness(Obj)
%��Ӧ�Ⱥ������ܾ���ĵ���    
%����Obj��     ÿ��������ܾ���
%���FitnV��   ÿ���������Ӧ��ֵ�����ܾ���ĵ���
    FitnV=1./Obj;
end

function Selch=BinaryTourment_Select(Chrom,dist)
%Chrom           ��Ⱥ
%dist            �������
%Selch           ��Ԫ������ѡ����ĸ���
    Obj=ObjFunction(Chrom,dist);            %������ȺĿ�꺯��ֵ����ÿ��������ܾ���
    FitnV=Fitness(Obj);                     %����ÿ���������Ӧ��ֵ�����ܾ���ĵ���
    [NIND,N]=size(Chrom);                   %NIND-��Ⱥ������N-��Ⱥ����
    Selch=zeros(NIND,N);                    %��ʼ����Ԫ������ѡ����ĸ���
    for i=1:NIND
        R=randperm(NIND);                   %����һ��1~NIND���������
        index1=R(1);                        %��һ���Ƚϵĸ������
        index2=R(2);                        %�ڶ����Ƚϵĸ������
        fit1=FitnV(index1,:);               %��һ���Ƚϵĸ������Ӧ��ֵ����Ӧ��ֵԽ��˵����������Խ�ߣ�
        fit2=FitnV(index2,:);               %�ڶ����Ƚϵĸ������Ӧ��ֵ
        %�������1����Ӧ��ֵ ���ڵ��� ����2����Ӧ��ֵ���򽫸���1��Ϊ��iѡ����ĸ���
        if fit1>=fit2
            Selch(i,:)=Chrom(index1,:);
        else
            %�������1����Ӧ��ֵ С�� ����2����Ӧ��ֵ���򽫸���2��Ϊ��iѡ����ĸ���
            Selch(i,:)=Chrom(index2,:);
        end
    end
end

function SelCh=Recombin(SelCh,Pc)
% �������
%SelCh    ��ѡ��ĸ���
%Pc       �������
% SelCh   �����ĸ���
    NSel=size(SelCh,1);
    for i=1:2:NSel-mod(NSel,2)
        if Pc>=rand %�������Pc
            [SelCh(i,:),SelCh(i+1,:)]=OX(SelCh(i,:),SelCh(i+1,:));
        end
    end
end
function [a,b]=OX(a,b)
%���룺a��bΪ����������ĸ���
%�����a��bΪ�����õ�����������
    L=length(a);
    while 1
        r1=randsrc(1,1,[1:L]);
        r2=randsrc(1,1,[1:L]);
        if r1~=r2
            s=min([r1,r2]);
            e=max([r1,r2]);
            a0=[b(s:e),a];
            b0=[a(s:e),b];
            for i=1:length(a0)
                aindex=find(a0==a0(i));
                bindex=find(b0==b0(i));
                if length(aindex)>1
                    a0(aindex(2))=[];
                end
                if length(bindex)>1
                    b0(bindex(2))=[];
                end
                if i==length(a)
                    break
                end
            end
            a=a0;
            b=b0;
            break
        end
    end
end
 

function SelCh=Mutate(SelCh,Pm,pSwap,pReversion,pInsertion)
% �������
%SelCh           ��ѡ��ĸ���
%Pm              �������
%pSwap           ѡ�񽻻��ṹ�ĸ���
%pReversion      ѡ����ת�ṹ�ĸ���
%pInsertion      ѡ�����ṹ�ĸ���
%SelCh           �����ĸ���
    NSel=size(SelCh,1);
    for i=1:NSel
        if Pm>=rand
            index=Roulette(pSwap,pReversion,pInsertion);
            route1=SelCh(i,:);
            if index==1                %�����ṹ
                route2=Swap(route1);
            elseif index==2            %��ת�ṹ
                route2=Reversion(route1);
            else                       %����ṹ
                route2=Insertion(route1);
            end
            SelCh(i,:)=route2;
        end
    end
end

function index=Roulette(pSwap,pReversion,pInsertion)
%pSwap           ѡ�񽻻��ṹ�ĸ���
%pReversion      ѡ����ת�ṹ�ĸ���
%pInsertion      ѡ�����ṹ�ĸ���
%index           ����ѡ�������ṹ
    p=[pSwap pReversion pInsertion];
    r=rand;
    c=cumsum(p);
    index=find(r<=c,1,'first');
end

function route2=Swap(route1)
%��������
%route1          ԭ·��1
%route2          ���������ṹ�任���·��2
    n=length(route1);
    seq=randperm(n);
    I=seq(1:2);
    i1=I(1);
    i2=I(2);
    route2=route1;
    route2([i1 i2])=route1([i2 i1]);
end

function route2=Reversion(route1)
%��ת�任
%route1          ·��1
%route2          ������ת�ṹ�任���·��2
    n=length(route1);
    seq=randperm(n);
    I=seq(1:2);
    i1=min(I);
    i2=max(I);
    route2=route1;
    route2(i1:i2)=route1(i2:-1:i1);
end

function route2=Insertion(route1)
%����任
%route1          ·��1
%route2          ��������ṹ�任���·��2
    n=length(route1);
    seq=randperm(n);
    I=seq(1:2);
    i1=I(1);
    i2=I(2);
    if i1<i2
        route2=route1([1:i1-1 i1+1:i2 i1 i2+1:end]);
    else
        route2=route1([1:i2 i1 i2+1:i1-1 i1+1:end]);
    end
end

function PlotRoute(route,x,y)
%route           ·��
%x,y             x,y����
    route=[route route(1)];
    plot(x(route),y(route),'k-o','MarkerSize',10,'MarkerFaceColor','w','LineWidth',1.5);
    xlabel('x');
    ylabel('y');
end