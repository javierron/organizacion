#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <cmath>
#include <random>
#include <functional>



using namespace std;


double get_distance(vector<int> a, vector<int> b, int dimensions);
string print_point(vector<int> v);

int main(){

	const int DATA_DIMENSIONS = 2;

	const int TESTBED_SIZE = 500;
	const int NUMBER_OF_CLUSTERS = 10;
	const int POINTS_PER_CLUSTER = 20;
	const int CLUSTER_RANGE = 5;
	const int CLUSTER_DISTANCE = 100; //remember distance is sum of powers, and sqrt is not used!

	random_device rDev;
	default_random_engine generator(rDev());
	uniform_int_distribution<int> dist(CLUSTER_RANGE, TESTBED_SIZE - CLUSTER_RANGE);

	auto get_random_int = bind(dist, generator);

	vector<vector<int>> centers;
	vector<vector<int>> points;


	if(NUMBER_OF_CLUSTERS < 2)
		return 1;

	
	vector<int> v;
	for(int i = 0; i < DATA_DIMENSIONS; ++i){
		v.push_back(get_random_int());
	}
	centers.push_back(v);
	

	for(int i = 1; i < NUMBER_OF_CLUSTERS; ++i){
		
		vector<int> v;
		bool isOnCorrectDistance = true;

		do{
			v.clear();
			isOnCorrectDistance = true;
			
			for(int i = 0; i < DATA_DIMENSIONS; ++i){
				v.push_back(get_random_int());
			}

			for(int j = 0; j < centers.size(); ++j){
				if( get_distance(v, centers[j], DATA_DIMENSIONS) < CLUSTER_DISTANCE ){
					isOnCorrectDistance = false;
				}
			}


		}while(!isOnCorrectDistance);

		centers.push_back(v);

	}



	ofstream centersFile;
	centersFile.open("centers.txt");
	
	for(int i = 0; i < NUMBER_OF_CLUSTERS; ++i){
		centersFile << print_point(centers[i]) << endl;
	}


	for(int i = 0; i < NUMBER_OF_CLUSTERS; ++i){

		vector<uniform_int_distribution<int>> distVector;

		for(int j = 0; j < DATA_DIMENSIONS; ++j){
			 uniform_int_distribution<int> dist(centers[i][j] - CLUSTER_RANGE, centers[i][j] + CLUSTER_RANGE);
			 distVector.push_back(dist);
		}

		for(int j = 0; j < POINTS_PER_CLUSTER; ++j){

			vector<int> newPoint;

			for(int j = 0; j < DATA_DIMENSIONS; ++j){

				newPoint.push_back(distVector[j](generator));

			}

			points.push_back(newPoint);
		}
	}



	ofstream pointsFile;
	pointsFile.open("points.txt");
	
	for(int i = 0; i < NUMBER_OF_CLUSTERS * POINTS_PER_CLUSTER; ++i){
		pointsFile << print_point(points[i]) << endl;
	}

	return 0;
}


double get_distance(vector<int> a, vector<int> b, int dimensions){

	double r = 0;

	for(int i = 0; i < dimensions; ++i){
		r += pow(b[i] - a[i], 2);
	}

	return r;

}

string print_point(vector<int> v){
	string s;

	for(int i = 0; i < v.size(); ++i){
		s +=  to_string(v[i]) + ",";
	}

	return s;
}


