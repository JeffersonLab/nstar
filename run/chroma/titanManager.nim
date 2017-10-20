##
## Structures used by titanManager
##

#[
        <Job>
                <name>testJob1</name>
                <checkNodes>1</checkNodes>
                <nodes>1</nodes>
                <checkWallTime>00:10:00</checkWallTime>
                <wallTime>00:10:00</wallTime>
                <executionCommand>serial /mnt/c/Users/danie/titanManager/examples/testJob.bash 'Successful!' /mnt/c/Users/danie/titanManager/examples/testJob1.out</executionCommand>
                <checkOutputCommand>serial /mnt/c/Users/danie/titanManager/examples/checkTestJob.bash /mnt/c/Users/danie/titanManager/examples/testJob1.out /mnt/c/Users/danie/titanManager/examples/testJob1Check.out</checkOutputCommand>
                <checkOutputScript>grep 'Successful' /mnt/c/Users/danie/titanManager/examples/testJob1Check.out</checkOutputScript>
                <campaign>Test</campaign>
                <inputFiles>
                  <elem>
                    <name>testJob.bash</name>
                    <fileDir>/mnt/c/Users/danie/titanManager/examples</fileDir>
                  </elem>
                  <elem>
                    <name>checkTestJob.bash</name>
                    <fileDir>/mnt/c/Users/danie/titanManager/examples</fileDir>
                  </elem>
                </inputFiles>
                <outputFiles>
                  <elem> 
                    <name>testJob1.out</name>
                    <fileDir>/mnt/c/Users/danie/titanManager/examples</fileDir>
                  </elem>
                </outputFiles>
        </Job>
]#

type
  PathFile_t* = object
    name*:               string
    fileDir*:            string

  CampaignType_t* = object
    name*:               string
    wallTime*:           string
    checkWallTime*:      string
    workDir*:            string
    header*:             string
    footer*:             string
    checkHeader*:        string
    checkFooter*:        string

  JobType_t* = object
    name*:               string
    checkNodes*:         int
    checkWallTime*:      string
    nodes*:              int
    wallTime*:           string
    executionCommand*:   string
    checkOutputCommand*: string
    checkOutputScript*:  string
    campaign*:           string
    inputFiles*:         seq[PathFile_t]
    outputFiles*:        seq[PathFile_t]

  TitanManager_t* = object
    Campaign*:           CampaignType_t
    Job*:                seq[JobType_t]
    
