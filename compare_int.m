grid=(-MAX+0.5: 1: MAX-0.5)*mesh;
Io2_10=squeeze(mean(Io10(MAX:MAX+1,:,:),1));
Io2_200=squeeze(mean(Io200(MAX:MAX+1,:,:),1));

Io2=[Io2_10,Io2_200];
figure;
contour(log10(Io2),log10([0.5 1 10 1e2 ]));
colormap hot 
colorbar
%legend('0.5','1','10','100 mW/mm^2')
%axis off
% xlabel('\bf z (\mum)')
% ylabel('\bf x (\mum)')
%  title ('\bf Intensity Distribution (mW/mm^2)')
 Io1_10=Io2_10(MAX,:);
  Io1_200=Io2_200(MAX,:);
  figure;
  semilogy(grid,Io1_10); hold on
 semilogy(grid,Io1_200,'r');
xlabel('\bf z (\mum)')
 ylabel('\bf intensity (mW/mm^2)')
%  title ('\bf Intensity Distribution (mW/mm^2)')

power =[0.5, 1, 2, 3, 4, 5,6];
threshold= 1./power;% corresponding to input power 0.5, 1, 2, 4, 5, 10mW
volume_10(length(threshold))=0;
volume_200(length(threshold))=0;
for i=1:length(threshold)
thr =threshold(i)*ones(size(Io10)); % intensity threshold is 1mw/mm^2
volume_10(i)=mesh*mesh*mesh*sum(sum(sum(Io10>=thr)))/1e9; % affacted volume in um^3
volume_200(i)=mesh*mesh*mesh*sum(sum(sum(Io200>=thr)))/1e9;
end
figure;
plot(power, volume_10,'-o'); hold on
plot(power, volume_200, 'r-o');
xlabel('\bf Input power (mW)')
 %ylabel('\bf affected volume (mm^3)')
title ('\bf Affected volume (mm^3, defined by the threshold = 1mW/mm^2)')
legend('10 um fiber','200 um fiber')

