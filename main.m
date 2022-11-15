clear
close all

Fun_name='F2'; % Name of the test function that can be from F1 to F23 
SearchAgents=10;  % Number of search agents
Max_iterations=1000; % Maximum numbef of iterations

% Load details of the selected benchmark function
[lowerbound,upperbound,dimension,fitness]=fun_info(Fun_name);
[Best_score,Best_pos,HLBO_curve]=HLBO(SearchAgents,Max_iterations,lowerbound,upperbound,dimension,fitness);


display(['The best solution obtained by HLBO is : ', num2str(Best_pos)]);
display(['The best optimal value of the objective funciton found by HLBO is : ', num2str(Best_score)]);

%% Draw objective space
plots=semilogx(HLBO_curve,'Color','g');
set(plots,'linewidth',2)
hold on
title('Objective space')
xlabel('Iterations');
ylabel('Best score');

axis tight
grid on
box on
legend('HLBO')


        
