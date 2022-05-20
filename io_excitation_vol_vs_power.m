function [exc_vol]=io_excitation_vol_vs_power(tpd10,tpd200);

power=1:1:15;
numpower=length(power);
exc_vol=zeros(numpower,3);

for i=1:numpower;
    p=power(i);
    vol10=length(find(tpd10>=1/p))/1e6;
    vol200=length(find(tpd200>=1/p))/1e6;
    exc_vol(i,:)=[p vol10 vol200];
end
  
figure;hold on;plot(exc_vol(:,1),exc_vol(:,2));
plot(exc_vol(:,1),exc_vol(:,3),'r')