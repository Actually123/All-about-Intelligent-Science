perminute=[242	245	244	248	247	248	242	244	246	242;
248	246	245	247	248	250	247	246	243	244;
246	248	250	252	248	250	246	248	245	250];
result=[0,0,0];
%��̬�Լ���
for i=1:3
    x_i=perminute(i,:)'; %��ȡ��i��group������״̬�µ��Ե��źŹ���ֵ
    [h,p]=lillietest(x_i); %��̬�Լ���
    result(i)=p; 
end
result %������̬�����pֵ
 
%�������Լ���
[p,stats]=vartestn(perminute'); %����vartestn�������з�������Լ���

p=anova1(perminute');
[p,table,stats]=anova2(perminute',5);

%���رȽ�
[c,m,h,gnames]=multcompare(stats); %���رȽ�
head={'�����','�����','��������','��������','���ֵ��','p-value'};
[head;num2cell(c)]  %������cתΪԪ�����飬����headһ����ʾ
head={'��ֵ�Ĺ���ֵ','��׼���'};
%m=num2cell(m);
[head;num2cell(m)]

