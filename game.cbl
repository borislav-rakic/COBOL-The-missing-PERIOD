       IDENTIFICATION DIVISION.
       PROGRAM-ID. GAME.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-GAME-QUIT             PIC X(1) VALUE 'N'.
           88 GAME-QUIT                     VALUE 'Y'.

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           PERFORM UNTIL GAME-QUIT
               PERFORM RECEIVE-USER-INPUT
           END-PERFORM.

           STOP RUN.
       
       RECEIVE-USER-INPUT.
           DISPLAY "Hello World!".
           SET GAME-QUIT TO TRUE.
