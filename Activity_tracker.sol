// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

contract Contract {
   address public owner;
   struct User_detail{
    string name ;
    uint weight;
    bool isRegistered;
   }
   struct activity_detail{
    string name;
    uint total_time;
    uint total_distance;
   }
   event userRegistered(string name ,address userAddress );
   event weightUpdated(string name ,address indexed userAddress );
   event distance_milestone(string name ,string message , address indexed userAddress);
   event workout_milestone(string name ,string message , address indexed userAddress);

   mapping(address => User_detail) users_table;
   mapping (address=> activity_detail) users_activity ;
   mapping(address => activity_detail[]) private workoutHistory;
   mapping(address => uint256) public totalWorkouts;
   mapping(address => uint256) public totalDistance;

   modifier onlyUser(){
    require(users_table[msg.sender].isRegistered, "Not a registred user");
    _;
   }

   function registerUser(string memory _name,uint _weight) public {
    require(!users_table[msg.sender].isRegistered, "user is already registred");
    users_table[msg.sender] = User_detail({
        name : _name,
        weight : _weight,
        isRegistered: true
    });
     emit userRegistered(_name, msg.sender);
   }

   function updateWeight(uint _weight) public onlyUser{
     User_detail storage profile = users_table[msg.sender];
     if(profile.weight < _weight){
        
     }
     profile.weight = _weight;
     emit weightUpdated(profile.name, msg.sender);
   }

   function logWorkout(string memory workout_Name , uint _time , uint distance)public onlyUser{
     activity_detail memory newUser = activity_detail({
        name: workout_Name,
        total_time: _time,
        total_distance: distance
     });

     workoutHistory[msg.sender].push(newUser);
     
     totalDistance[msg.sender]++;
     totalWorkouts[msg.sender]++;

     if(totalDistance[msg.sender]== 10){
      emit distance_milestone(newUser.name, "milestone reached", msg.sender);
     }
     if(totalWorkouts[msg.sender]==10){
      emit workout_milestone(newUser.name, " workout milestone reached", msg.sender);
     }
     
   }

}
