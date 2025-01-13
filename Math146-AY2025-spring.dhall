-- Time-stamp: <2025-01-13 Mon 16:43 EST - george@calliope>
let Dow = < Mon | Tue | Wed | Thu | Fri | Sat | Sun >

let concat = https://prelude.dhall-lang.org/List/concat

let EventTime = { start : Text, end : Text }

let ScheduleDetails =
      < DowTufts : { dow : Dow, time : EventTime, location : Text }
      | DowActual : { dow : Dow, time : EventTime, location : Text }
      | DowDue : { dow : Dow, deadline : Text }
      | Date : { date : Text, time : EventTime, location : Text }
      | DateDue : { date : Text, deadline : Text }
      >

let CourseComponent =
      < Lecture :
          { sched : List ScheduleDetails
          , description : Text
          , topics : List Text
          }
      | Recitation :
          { sched : List ScheduleDetails
          , description : Text
          , instructor : Text
          , topics : List Text
          }
      | Assignment :
          { sched : List ScheduleDetails
          , description : Text
          , assignments : List Text
          }
      | Exam : { sched : List ScheduleDetails, description : Text }
      >

let Task =
      < Repeating : { description : Text, dow : Dow, taskStaffList : List Text }
      | Single : { description : Text, deadline : Text, taskStaff : Text }
      | Meeting :
          { description : Text, time : EventTime, location : Text, dow : Dow }
      >

let tasks =
      [ Task.Meeting
          { description = "Office hours"
          , dow = Dow.Wed
          , time = { start = "13:30", end = "14:30" }
          , location = "JCC 559"
          }
      , Task.Meeting
          { description = "Office hours"
          , dow = Dow.Thu
          , time = { start = "14:30", end = "15:30" }
          , location = "JCC 559"
          }
      ]

let homework =
      CourseComponent.Assignment
        { description = "Homework collected on gradescope"
        , sched =
          [ ScheduleDetails.DowDue { dow = Dow.Fri, deadline = "23:59" } ]
        , assignments = ./topics/assignments.dhall : List Text
        }

let lectures =
      CourseComponent.Lecture
        { sched =
          [ ScheduleDetails.DowTufts
              { dow = Dow.Mon
              , time = { start = "9:00", end = "10:15" }
              , location = "JCC 280"
              }
          , ScheduleDetails.DowTufts
              { dow = Dow.Wed
              , time = { start = "9:00", end = "10:15" }
              , location = "JCC 280"
              }
          ]
        , topics = ./topics/lectures.dhall : List Text
        , description = "course lecture"
        }

let midterm1 =
      CourseComponent.Exam
        { sched =
          [ ScheduleDetails.Date
              { date = "2025-02-19"
              , time = { start = "9:00", end = "10:15" }
              , location = "JCC 280"
              }
          ]
        , description = "midterm 1"
        }

let midterm2 =
      CourseComponent.Exam
        { sched =
          [ ScheduleDetails.Date
              { date = "2025-03-31"
              , time = { start = "9:00", end = "10:15" }
              , location = "JCC 280"
              }
          ]
        , description = "midterm 2"
        }

let final =
      CourseComponent.Exam
        { sched =
          [ ScheduleDetails.Date
              { date = "2025-05-09"
              , time = { start = "8:30", end = "10:30" }
              , location = "TBA"
              }
          ]
        , description = "final exam"
        }

in  [ { courseAY = "AY2024-2025"
      , courseSem = "spring"
      , title = "Math146"
      , sections = [ "01" ]
      , chair = "George McNinch"
      , instructors = [] : List Text
      , tas = [] : List Text
      , courseDescription = "Abstract Algebra II (Galois Theory)"
      , target =
        { dir = "course-pages", base = "Math146", org = "/home/george/org/" }
      , courseComponents = [ lectures, homework, midterm1, midterm2, final ]
      , courseTasks = tasks : List Task
      }
    ]
