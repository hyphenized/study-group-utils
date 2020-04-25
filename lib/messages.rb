module Messages
  HELP = <<~SCREEN.freeze


        #{"StudyGroups Utils 0.1".center 60}
        #{"=====================".center 60}

        #{"Student List".center 60}
        #{"-" * 60}
        %s

        #{"Commands".center 60}

        generate <opts>           Generate groups
        match <opts>              Matches students to assignments
        exit                      Ends the program

        Type help <command> to get more information about a command
        Type help to show this screen again
        SCREEN
end
