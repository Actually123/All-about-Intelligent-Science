load -ASCII mushroom.mat;
MushroomBooleMatrix=BooleMatrix(mushroom);
minSup = 0.2;
Apriori(MushroomBooleMatrix,minSup);

function Apriori(T, minSup)
    M = size(T,1);%������
    % Number of attributes in the dataset
    N = size(T,2);%������
    % Find frequent item sets of size 1 (list of all items with minSup)
    L={};
    for i = 1:N
        S = sum(T(:,i))/M;
        if S >= minSup
            L = [L; i];
        end
    end
    LL=L;
    %Find frequent item sets of size >=2 and from those identify rules with minConf
    % Initialize Counter
    disp(numel(LL));%%%%%%%%%%%%%%%%%%%%%%%
% Initialize Counter
    k=1;%Ƶ���������
% Iterations
    while ~isempty(LL)%����ֱ�������isempty()�������пա�whileѭ��������Ƶ����Ĵ�ѭ��41-87��,��L{k}-->L{k+1}�仯
        C={}; 
        L={};
        w=0;    
        for r=1:numel(LL)
            for i=r:(numel(LL)-1)
                Ecount=0;
                for j=1:(k-1)
                    if(LL{r}(j)==LL{i+1}(j))
                        Ecount=Ecount+1;
                    else
                        break;
                    end
                end
                if(Ecount==(k-1))
                    w=w+1;
                    NEW=LL{r};
                    NEW(k+1)=LL{i+1}(k);
                    C{w}=NEW;
                else
                    break;
                end
            end
        end
        w=0;
        for r=1:numel(C)            
            S=T(:,C{r});
            [~, x]=size(S);
            SS=ones(M,1);
            for i=1:x
                SS=SS&(S(:,i));
            end
            Sup=sum(SS)/M;
            if Sup >= minSup
                w=w+1;
               L{w}=C{r};
            end
        end
        LL=L;
        disp(numel(LL));%%%%%%%%%%%%%%%%%%
        % Increment Counter
        k=k+1;
    end
end

function [ B ] = BooleMatrix(A)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
M=size(A,1);
N=size(A,2);
B=zeros(M,N);
for i=1:M
    for j=1:N
        B(i,A(i,j))=1;
    end 
end
end
