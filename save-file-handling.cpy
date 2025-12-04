       LOAD-GAME-ROUTINE.
           OPEN INPUT SAVE-FILE.

           PERFORM UNTIL EOF-SAVE-REACHED
               READ SAVE-FILE
                   AT END
                       SET EOF-SAVE-REACHED TO TRUE
                   NOT AT END
                       PERFORM LOAD-SAVE
               END-READ
           END-PERFORM.

           CLOSE SAVE-FILE.

           SET EXPLORING TO TRUE.

           DISPLAY " ".
       
       LOAD-SAVE.
      *    The first line is the player's health.
           IF WS-SAVE-RECORD-COUNT = 0
               MOVE SAVE-RECORD TO WS-PUNCH-CARD
           ELSE IF WS-SAVE-RECORD-COUNT = 1
               MOVE SAVE-RECORD TO FILES-MISSING-PERIOD
           ELSE IF WS-SAVE-RECORD-COUNT = 2
               MOVE SAVE-RECORD TO FILES-PUNCH-CARD
           ELSE IF WS-SAVE-RECORD-COUNT = 3
               MOVE SAVE-RECORD TO COMPILER-SOLVED
           ELSE IF WS-SAVE-RECORD-COUNT = 4
               MOVE SAVE-RECORD TO CURRENT-DIALOGUE-INDEX
           END-IF.

           ADD 1 TO WS-SAVE-RECORD-COUNT.
       
       NEW-GAME-ROUTINE.
           OPEN OUTPUT SAVE-FILE.

           WRITE SAVE-RECORD FROM 'N'.
           WRITE SAVE-RECORD FROM 'N'.
           WRITE SAVE-RECORD FROM 'N'.
           WRITE SAVE-RECORD FROM 'N'.
           WRITE SAVE-RECORD FROM 001.

           CLOSE SAVE-FILE.
       
       SAVE-QUIT-LOGIC.
           OPEN OUTPUT SAVE-FILE.

           WRITE SAVE-RECORD FROM WS-PUNCH-CARD.
           WRITE SAVE-RECORD FROM FILES-MISSING-PERIOD.
           WRITE SAVE-RECORD FROM FILES-PUNCH-CARD.
           WRITE SAVE-RECORD FROM COMPILER-SOLVED.
           WRITE SAVE-RECORD FROM ACTION(2).

           CLOSE SAVE-FILE.

           STOP RUN.
           