P1=0.000004; % ��ľ��Ȼ�Ż����
P2 =0.01; %�յس�����ľ����
%����յس�����ľ����ľȼ�ձ�ɿյ�ֻ��Ҫ1�غ�
size =400; %ɭ�ִ�С
trees =zeros(size,size);
d1 = [size , 1:size-1];
d2 = [2:size , 1];
result = image(cat(3, (trees == 2), (trees == 1), zeros(size)))
for i =1:2000
    neighbour = (trees(d1,:)==2)+(trees(d2,:)==2)+(trees(:,d1)==2)+(trees(:,d2)==2);%��Χ�Ż���ľ����
    trees =trees+(trees==1 &(neighbour>0|rand(size,size)<=P1)) ...%��Ȼ�Ż�����ΧӰ���Ż�
      + (neighbour==0 &rand(size,size)<=P2& trees==0) +(trees==2)*(-2); %��Χ�޻���Ŀյػָ�����ľ��ȼ����ľ��ɿյ�
  set(result, 'cdata', cat(3, (trees == 2), (trees == 1), zeros(size)) );
  drawnow
  pause(0.01)
end
