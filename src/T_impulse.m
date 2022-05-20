%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% light induced thermal response
% Temperature distribution, relaxiation afer 1ms 1mW impulse stimulus
%  by J. Wang, Oct.2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [time]=T_impulse()

MAX = evalin('base', 'MAX');
mesh= evalin('base', 'mesh');
Ti= evalin('base', 'To');

k=0.56*1e-3;% heat conductivity, in W/mm/K
rho= 1.07*1e-3; % density of brain tissue in g/mm3
c=3.6; % specific heat, J/(gK)
% power= 1e-3; % power= 1mW in w
% t=1e-3; % stimulation time= 1msec
% mu_a= 0.1; % abs coeff in mm^-1
alpha=k/rho/c; % in mm^2/sec

dt=1e-4; % time interval in sec
nt=50;% 

coeff = 6*alpha*dt/(mesh*mesh*1e-6); 

grid=mesh*(-MAX+0.5: 1: MAX-0.5);


%% heat diffusion

T=cell(nt,1);
T{1,1}= Ti; % initial temperature 

tic
for i=2:nt
       T{i,1}= coeff.*laplace(T{i-1,1}) +(1-coeff).*T{i-1,1};   
   
end


T2(nt,2*MAX,2*MAX)=0;
for i=1:nt
    temp=T{i,1};
 T2(i,:,:)=(mean(temp(MAX:MAX+1,:,:),1));

end

assignin('base','dt',dt);
assignin('base','T2',T2);


figure;
n_t=round(1e-3/dt);
for i=1:n_t:nt
semilogy(grid,squeeze(T2(i,MAX,:)),'-'); hold on
xlim([-100 1000])
end

xlabel('\bfz (\mum)')
ylabel('\bfdT (K)')
hold off
legend(['dt=',num2str(n_t*dt*1e3),'msec'])
time=toc;
end

function [P]=laplace(p)

    px1=cat(1, p(1,:,:), p(1:end-1,:,:));
    px2=cat(1, p(2:end,:,:), p(end,:,:));   
 
    py1=cat(2, p(:,1,:), p(:,1:end-1,:));
    py2=cat(2, p(:,2:end,:), p(:,end,:)); 
 
    pz1=cat(3, p(:,:,1), p(:,:,1:end-1));
    pz2=cat(3, p(:,:,2:end), p(:,:,end));
      P=(px1+px2+py1+py2+pz1+pz2)./6;  

end