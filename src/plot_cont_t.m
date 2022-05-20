[~,ind_max]=max(T2_10(1,MAX,:));
Tmax_10(400)=0;
for t=1:400
    if t<=200
    Tmax_10(t)=sum(T2_10(1:n_t:n_t*t,MAX,ind_max));
    else
        Tmax_10(t)=sum(T2_10((1+(t-200)*n_t):n_t:400,MAX,ind_max));
    end
end

[~,ind_max]=max(T2_200(1,MAX,:));
Tmax_200(400)=0;
for t=1:400
    if t<=200
    Tmax_200(t)=sum(T2_200(1:n_t:n_t*t,MAX,ind_max));
    else
        Tmax_200(t)=sum(T2_200((1+(t-200)*n_t):n_t:400,MAX,ind_max));
    end
end



figure
plot(1:400, Tmax_10); hold on
plot(1:400, Tmax_200,'r'); hold on
plot(1:400, max(Tmax_10)*[ones(1,200), zeros(1,200)],'g');
xlabel('\bf Time (msec)')
ylabel('\bf dT (K)')
ylim([0 0.5])
hold off
legend('10 um fiber','200 um fiber','stimulation, 1mW, 200ms continuous')
