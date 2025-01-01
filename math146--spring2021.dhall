let Semester = < Fall | Spring | Summer >

let Dow = < Mon | Tue | Wed | Thu | Fri >

in  { courseId = "Math 146"
    , instructor =
      { name = "George McNinch", email = "george.mcninch@tufts.edu" }
    , AY = "AY2020-2021"
    , semester = Semester.Spring
    , lectures =
      { blockId = "E+MW"
      , meets =
        [ { day = Dow.Mon, start = "10:30", end = "11:00" }
        , { day = Dow.Wed, start = "10:30", end = "11:00" }
        ]
      }
    }
