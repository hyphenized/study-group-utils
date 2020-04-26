# Study Group Utils

The all-in-one tool to generate study groups and code review buddies. Built using Ruby for educational purposes.

## Features

-  You can add or disable commands in a plug & play fashion
-  Can be used with CLI arguments
- Easily customizable using a config file
- Outputs files in several formats (json, yaml and csv)
- Generates study groups using a pseudo random algorithm that takes past occurrences as inputs to ensure that a student gets matched first with others that has not worked with.
- Generates a random list of PRs that a student has to review

## Config files

Default app config.json :

    {
    	"past_files_prefix": "week", 
    	"past_files_format": "csv",
    	"past_files_folder": "past_groups", # reads groups in .csv format
    	"past_assignments_folder": "past_assignments", # reads assignments.json
    	"student_list": "students.json",
    	"group_size": 3,
    	"verbose": true
    }

### past_groups folder
Contains .csv files with the following columns and rows

    study_group,name  
    1,Rai Delgado  
    1,Freddy Munive  
    1,Jorge Luis Alayo  
    2,Joel Eche  
    2,Ricardo Huamani  
    2,Robert Medina  
    3,Alexander Chavarria  
    3,Saida Del Valle Brito  
    3,Sebastian Zanabria  
    4,Adonai Luque  
    4,Andrés Del Carpio  
    4,Benjamin Maguiña  
    5,Alessandro Chumpitaz  
    5,Victor Rodriguez  
    5,Wilber Carrascal  
    6,Albert Castellano  
    6,Joaquín Meza  
    6,Jorge Gonzales  


### students.json
ID and name are required

    {  
      "id": "36",  
      "name": "Victor Rodriguez"  
    }


### assignments.json in past_assignment folder
ID, url and submittedBy are required

    [
	  # Each assignments has this form
     {  "id": "2",  
      "assignmentName": "Structuring HTML Pages",  
      "url": "https://github.com/codeableorg/html-essentials/pull/1",  
      "lessonPath": "/curriculum/module1/week1/day1-wd/3-HTML-essentials.md/",  
      "submittedBy": [ { "id": "23" } ]
      }
    ]


## Screenshots

### menu
![main app menu](https://i.imgur.com/S1ekzFP.png)

### usage
![help with usage](https://i.imgur.com/5WLnXBi.png)

### matchpr output in several formats
![output in several formats](https://i.imgur.com/d0aRDqT.png)

## License
[MIT](https://github.com/Deprofets/study-group-utils/blob/master/LICENSE)
