states = csvread('C:\Users\ARay Lab\Desktop\game-theoretic-feedback-loop\RRG\state_log.csv');

xs = states(:,1);
ys = states(:,2);
costs = states(:,3);
%costs = states(:,3);

h = [xs ys];

[v, c] = voronoin(h);

for i = 1:length(c) 
if all(c{i}~=1)   % If at least one of the indices is 1, 
                  % then it is an open region and we can't 
                  % patch that.
              disp(costs(i));
    patch(v(c{i},1),v(c{i},2), costs(i)); % use color i.
end
end
axis([0 max(xs) 0 max(ys)]);
