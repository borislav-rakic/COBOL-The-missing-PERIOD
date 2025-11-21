       IDENTIFICATION DIVISION.
       PROGRAM-ID. GAME.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT SAVE-FILE ASSIGN TO 'game.save'
               ORGANIZATION IS LINE SEQUENTIAL
               ACCESS MODE IS SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD SAVE-FILE
           RECORD CONTAINS 100 CHARACTERS
           DATA RECORD IS SAVE-RECORD.
       01 SAVE-RECORD              PIC X(100).

       WORKING-STORAGE SECTION.
       01 WS-EOF-FLAG              PIC X(1) VALUE 'N'.
           88 EOF-REACHED                   VALUE 'Y'.
       01 WS-RECORD-COUNT          PIC 9(2) VALUE 0.

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

       01 PLAYER-DATA.
           02 PLAYER-HEALTH        PIC ZZ9.

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           PERFORM UNTIL GAME-QUIT
               PERFORM RECEIVE-USER-INPUT
           END-PERFORM.

           STOP RUN.
       
       RECEIVE-USER-INPUT.
           IF MAIN-MENU
               PERFORM MAIN-MENU-ROUTINE
           ELSE IF EXPLORING
               PERFORM EXPLORING-ROUTINE
           END-IF.

       MAIN-MENU-ROUTINE.
           PERFORM UNTIL INPUT-VALID
               DISPLAY "Welcome adventurer! Please select an option by "
                       "typing the number into the command line:"
               DISPLAY "1: Load Game"
               DISPLAY "2: New Game"

               ACCEPT USER-INPUT

               SET INPUT-VALID TO TRUE
               IF USER-INPUT = "1"
                   PERFORM LOAD-GAME-ROUTINE
               ELSE IF USER-INPUT = "2"
                   PERFORM NEW-GAME-ROUTINE
               ELSE
                   SET INPUT-VALID TO FALSE
                   DISPLAY "Invalid input!"
                   DISPLAY " "
               END-IF
           END-PERFORM.

           SET GAME-QUIT TO TRUE.
       
       LOAD-GAME-ROUTINE.
           OPEN INPUT SAVE-FILE.

           PERFORM UNTIL EOF-REACHED
               READ SAVE-FILE
                   AT END
                       SET EOF-REACHED TO TRUE
                   NOT AT END
                       PERFORM LOAD-SAVE
               END-READ
           END-PERFORM.

           CLOSE SAVE-FILE.

           DISPLAY "LOADING".
       
       LOAD-SAVE.
      *    The first line is the player's health.
           IF WS-RECORD-COUNT = 0
               MOVE SAVE-RECORD TO PLAYER-HEALTH
           END-IF.

           DISPLAY PLAYER-HEALTH.

           ADD 1 TO WS-RECORD-COUNT.
       
       NEW-GAME-ROUTINE.
           DISPLAY "CREATING NEW GAME".

       EXPLORING-ROUTINE.
           DISPLAY "EXPLORING".
