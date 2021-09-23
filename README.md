# qquiz

Quickfire q quizzes for training purposes

One quiz per week

## Usage

Start `quizzer.q` listening on a port & passing question file as first arg (question file should
have one question per line, no other lines)

```bash
$ q quizzer.q -p 5050 week4/questions.txt
```

Wait for connections and once ready, call `start` function

```q
q)start[]
```

All questions will be asked automatically, 45 seconds apart.

Once all questions are asked, users will be kicked out. Can then mark using

```q
q)mark answers
```

Marked answers will be saved in global table `marked`
