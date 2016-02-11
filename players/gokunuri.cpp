/*
   TODO


*/

#include "players.hpp"
#include <list>
#include <utility>
#include <vector>
#include <map>
#include <fstream>

double territoryMerits = 1.;
double selfTerritoryMerits = 0.3;
double hurtingMerits = 0.1;
double hidingMerits = 0.1;
double moveMerits = 0.1;
double distanceFromSpearFriendMerits = 0.1;
double distanceFromSwordFriendMerits = 0.1;
double distanceFromAxeFriendMerits = 0.1;
double distanceFromCenterMerits = 0.1;

list<int> bestPlay;
list<int> currentPlay;
double bestMerits;

map<double,vector<list<int>>> bestPlays;

vector<double> parse2double( string str ) {
  vector<double> params;
  string delim = " ";
  string::size_type start = 0;
  while(true) {
	string::size_type end = str.find(delim, start);
	if ( end != string::npos ) {
	  params.push_back( atof(str.substr(start,end-start).c_str()) );
	} else{
	  params.push_back( atof(str.substr(start,str.length()-start).c_str()) );
	  break;
	}
	start = end + delim.length();
  }
  return params;
}

struct gokunuri: Player {
  gokunuri() {
	srand((unsigned int)time(NULL));
  }

  void readSettings(string filename, int samurainum) {
	ifstream ifs(filename.c_str());
	string buf;
	for ( int i = 0; i < 6; i++ ) {
	  getline(ifs,buf);
	  vector<double> params = parse2double(buf);
	  if ( i == samurainum ) {
		setParam(params);
		break;
	  }
	}
  }

  void setParam(vector<double> params) {
	territoryMerits = params[0];
	selfTerritoryMerits = params[1];
	hurtingMerits = params[2];
	hidingMerits = params[3];
      moveMerits = params[4];
      distanceFromSpearFriendMerits = params[5];
      distanceFromSwordFriendMerits = params[6];
      distanceFromAxeFriendMerits = params[7];
      distanceFromCenterMerits = params[8];
  }

  void plan(GameInfo& info, SamuraiInfo& me, int power, double merits) {
	vector<list<int>> candidates;
	if(bestPlays.find(merits) == bestPlays.end()) {
	  vector<list<int>> candidates;
	  candidates.push_back(currentPlay);
	  bestPlays.insert(map<double,vector<list<int>>>::value_type(merits,candidates));
	} else {
	  bestPlays[merits].push_back(currentPlay);
	}

    static const int required[] = {0, 4, 4, 4, 4, 2, 2, 2, 2, 1, 1};
    for (int action = 1; action != 11; action++) {
      if (required[action] <= power &&
	  info.isValidAt(action, me.curX, me.curY, me.hidden)) {
	currentPlay.push_back(action);
	Undo undo;

    map<string,int> evalParams;
	info.tryAction(action, undo, evalParams);
    int territory = evalParams["territory"];
    int selfTerritory = evalParams["selfTerritory"];
    int injury = evalParams["injury"];
    int hiding = evalParams["hiding"];
          int move = evalParams["moveDistance"];
          int spearFriendDistance = evalParams["spearFriendDistance"];
          int swordFriendDistance = evalParams["swordFrinedDistance"];
          int axeFriendDistance = evalParams["axeFriendDistance"];
          int distanceFromCenter = evalParams["distanceFromCenter"];
	double gain = territoryMerits*territory
	  + selfTerritoryMerits*selfTerritory
	  + hurtingMerits*injury
	  + hidingMerits*hiding
          + moveMerits*move
          + distanceFromSpearFriendMerits*spearFriendDistance
          + distanceFromSwordFriendMerits*swordFriendDistance
          + distanceFromAxeFriendMerits*axeFriendDistance
          + distanceFromCenterMerits*(14-distanceFromCenter);
	plan(info, me, power-required[action], merits+gain);
	undo.apply();
	currentPlay.pop_back();
      }
    }
  }
  void play(GameInfo& info) {
    currentPlay.clear();
    bestMerits = -1;
	bestPlays.clear();
	readSettings("setting/gokunuri_recipe.txt", info.weapon+info.side*3); // read setting file

    plan(info, info.samuraiInfo[info.weapon], 7, 0);

	map<double,vector<list<int>>>::reverse_iterator it = bestPlays.rbegin();
	vector<list<int> > maxCandidates = (*it).second;
	bestPlay = maxCandidates[rand()%maxCandidates.size()];
	//	bestPlay = maxCandidates[0];

    for (int action: bestPlay) {
      cout << action << ' ';
    }
  }
};

Player* player = new gokunuri();
