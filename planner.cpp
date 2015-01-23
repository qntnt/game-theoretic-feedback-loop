#include <iostream>
#include <ompl/control/SimpleSetup.h>
using namespace std;
namespace ob = ompl::base;
namespace og = ompl::geometric;

void planWithSimpleSetup(void);

int main()
{
	planWithSimpleSetup();
}

void planWithSimpleSetup(void)
{
	// Construct the state space
	ob::StateSpacePtr space(new ob::SE3StateSpace());
	
	ob::RealVectorBounds bounds(3);
	bounds.setLow(-1);
	bounds.setHigh(1);

	space->as<ob::SE3StateSpace>()->setBounds(bounds);

	og::SimpleSetup ss(space);
	ob::ScopedState<> start(space);
	start.random();

	ob::ScopedState<> goal(space);
	goal.random();

	ss.setStartAndGoalStates(start, goal);

	ob::PlannerStatus solved = ss.solve(1.0);

	if(solved)
	{
		cout << "Found solution:" << endl;
		ss.simplifySolution();
		ss.getSolutionPath().print(cout);
	}
}

