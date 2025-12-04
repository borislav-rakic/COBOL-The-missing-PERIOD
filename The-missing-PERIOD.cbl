       IDENTIFICATION DIVISION.
       PROGRAM-ID. THE-MISSING-PERIOD.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT SAVE-FILE ASSIGN TO 'game.save'
               ORGANIZATION IS LINE SEQUENTIAL
               ACCESS MODE IS SEQUENTIAL.
           
           SELECT DIALOGUE-FILE ASSIGN TO 'dialogue.txt'
               ORGANISATION IS LINE SEQUENTIAL
               ACCESS MODE IS SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD SAVE-FILE
           RECORD CONTAINS 100 CHARACTERS
           DATA RECORD IS SAVE-RECORD.
       01 SAVE-RECORD              PIC X(100).

       FD DIALOGUE-FILE
           RECORD CONTAINS 500 CHARACTERS
           DATA RECORD IS DIALOGUE-RECORD.
       01 DIALOGUE-RECORD          PIC X(500).

       WORKING-STORAGE SECTION.
       01 WS-EOF-SAVE-FLAG         PIC X(1) VALUE 'N'.
           88 EOF-SAVE-REACHED              VALUE 'Y'.
       01 WS-SAVE-RECORD-COUNT     PIC 9(2) VALUE 0.

       01 WS-EOF-DIALOGUE-FLAG     PIC X(1) VALUE 'N'.
           88 EOF-DIALOGUE-REACHED          VALUE 'Y'.
       01 WS-DIALOGUE-RECORD-COUNT PIC 9(3) VALUE 0.

       01 WS-GAME-QUIT             PIC X(1) VALUE 'N'.
           88 GAME-QUIT                     VALUE 'Y'.

       01 USER-INPUT               PIC X(80).

       01 INPUT-VALID-FLAG         PIC X(1) VALUE 'N'.
           88 INPUT-VALID                   VALUE 'Y'
                                   WHEN SET TO FALSE IS 'N'.

      *We define a GAME-STATE AND MULTIPLE conditions TO determine the
      *current state of the game.
       01 GAME-STATE               PIC X(1) VALUE 'A'.
           88 MAIN-MENU            VALUE 'A'.
           88 EXPLORING            VALUE 'B'.
       
      *We define a TABLE that will hold world information and dialogue.
       01 WORLD-TABLE.
           02 DIALOGUE             PIC X(500) OCCURS 200 TIMES.

       01 WS-STRING-POINTER        PIC 9(2) VALUE 1.
       
       01 AVAILABLE-ACTIONS.
           02 ACTION               PIC X(500) OCCURS 16 TIMES.
       01 CURRENT-ACTION-COUNTER   PIC 9(2) VALUE 1.
       01 ACTION-VALID-FLAG        PIC X(1) VALUE 'N'.
           88 ACTION-VALID                  VALUE 'Y'
                                   WHEN SET TO FALSE IS 'N'.

       01 CURRENT-DIALOGUE-INDEX   PIC 9(3) VALUE 1.

      *These variables will hold VALUES determining the progress OF
      *the player.
       01 TASKS-COMPLETED.
           02 WS-PUNCH-CARD        PIC X(1) VALUE 'N'.
           02 FILES-MISSING-PERIOD PIC X(1) VALUE 'N'.
           02 FILES-PUNCH-CARD     PIC X(1) VALUE 'N'.
           02 COMPILER-SOLVED      PIC X(1) VALUE 'N'.

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           PERFORM UNTIL GAME-QUIT
               PERFORM RECEIVE-USER-INPUT
           END-PERFORM.

           STOP RUN.

       INITIALIZE-WORLD-TABLE.
           OPEN INPUT DIALOGUE-FILE.
           
           PERFORM UNTIL EOF-DIALOGUE-REACHED
               READ DIALOGUE-FILE
                   AT END
                       SET EOF-DIALOGUE-REACHED TO TRUE
                   NOT AT END
                       MOVE DIALOGUE-RECORD TO 
                           DIALOGUE(WS-DIALOGUE-RECORD-COUNT + 1)
                       ADD 1 TO WS-DIALOGUE-RECORD-COUNT
               END-READ
           END-PERFORM.

           CLOSE DIALOGUE-FILE.
       
       RECEIVE-USER-INPUT.
           IF MAIN-MENU
               PERFORM MAIN-MENU-ROUTINE
           ELSE IF EXPLORING
               PERFORM EXPLORING-ROUTINE
           END-IF.

       MAIN-MENU-ROUTINE.
           PERFORM INITIALIZE-WORLD-TABLE.

           PERFORM UNTIL INPUT-VALID
               DISPLAY "Welcome adventurer! Please select an option by "
                       "typing the number into the command line:"
               DISPLAY "1: Load Game"
               DISPLAY "2: New Game"
               DISPLAY " "
               DISPLAY "Input: " WITH NO ADVANCING

               ACCEPT USER-INPUT

               SET INPUT-VALID TO TRUE
      *        We check only the first character in the user input.
               IF USER-INPUT(1:1) = "1"
                   PERFORM LOAD-GAME-ROUTINE
               ELSE IF USER-INPUT(1:1) = "2"                            
                   PERFORM NEW-GAME-ROUTINE
                   PERFORM LOAD-GAME-ROUTINE
               ELSE
                   SET INPUT-VALID TO FALSE
                   DISPLAY "Invalid input!"
                   DISPLAY " "
               END-IF
           END-PERFORM.

       EXPLORING-ROUTINE.
      *    First we check if certain conditions are met, in which case  
      *    the player would be redirected TO different DIALOGUE.
           PERFORM CHECK-CONDITIONS.

           DISPLAY FUNCTION TRIM(DIALOGUE(CURRENT-DIALOGUE-INDEX)
               TRAILING).

      *    We RESET all available actions and save the next available
      *    actions.    
           PERFORM RESET-AVAILABLE-ACTIONS.
           PERFORM INIT-AVAILABLE-ACTIONS.

           IF FUNCTION TRIM(ACTION(1)) = "ENDING"
               MOVE ACTION(2) TO CURRENT-DIALOGUE-INDEX
               PERFORM ENDING-LOGIC
           ELSE IF FUNCTION TRIM(ACTION(1)) NOT EQUAL "NONE"
               DISPLAY "------------------"
               DISPLAY "Available actions:"

               PERFORM DISPLAY-AVAILABLE-ACTIONS

               DISPLAY "Input: " WITH NO ADVANCING

               ACCEPT USER-INPUT

               IF USER-INPUT = "SAVE"
                   PERFORM SAVE-QUIT-LOGIC
               END-IF
               
               DISPLAY "+++++++++++++++++++++++++++++++++++++++++"

               PERFORM CHECK-ACTION-VALIDITY
           ELSE
               SET CURRENT-DIALOGUE-INDEX TO ACTION(2).
       
       ENDING-LOGIC.
           PERFORM UNTIL CURRENT-DIALOGUE-INDEX > 178
               DISPLAY FUNCTION
                   TRIM(DIALOGUE(CURRENT-DIALOGUE-INDEX)(2:499))
               CALL "C$SLEEP" USING DIALOGUE(CURRENT-DIALOGUE-INDEX)
                                       (1:1)
               ADD 1 TO CURRENT-DIALOGUE-INDEX
           END-PERFORM.

           SET GAME-QUIT TO TRUE.
       
       COPY save-file-handling.
       COPY available-actions.
       COPY checking-functions.
