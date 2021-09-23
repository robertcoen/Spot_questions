\c 30 260

handles:([]user:();handle:())
answers:([] t:(); n:(); u:(); a:())
currentquestion:0
receiveanswer:0b

// users must supply username
.z.pw:{[u;p] not null u}

// when a client connects, log the handle and reset their .z.pi definition
clientpi:{[h;x] $[x~enlist "\n";"\n"; [h(`answer;x);"answer sent\n"]]}
welcome:{
 system"c 23 2000";
 -1"\n\nWelcome to the kdb+ Spotquestion Quiz Game, brought to you in association with Brennans IT - Todays Code Today.\n\nThe rules are simple:\n\n1. To answer a question, just type the answer in the terminal\n2. Questions will be published once I have everyones answers\n3. After each question you will be sent everyone's answers.  You can't submit an answer after you've seen all the answers\n4. 2 points for a correct answer\n5. 3 points for the first correct answer\n6. You can submit multiple answers to each question, the last answer sent is the one accepted\n\nGood luck!"}

.z.po:{
 `handles insert (.z.u;.z.w);
 (neg .z.w)({`.z.pi set x@neg .z.w};clientpi);
 (neg .z.w)(welcome;`)}

// drop handles
.z.pc:{delete from `handles where handle=x}
.z.pg:.z.ph:.z.pp:.z.ws:{'"oh no you didn't"}
.z.pi:{$[0=.z.w; .Q.s value x;'"nice try"]}
.z.ps:{$[not `answer~first x; '"think you are smart?"; value x]}

// store an answer
answer:{if[receiveanswer;.[insert;(`answers;0N!(.z.p; currentquestion;.z.u;x));()]]}

// send a question
sendquestion:{
 receiveanswer::1b;
 currentquestion+::1;
 (neg handles`handle)@\:(-1;"\n\nQuestion ",string[currentquestion]," at time ",(string `second$.z.T),"\n\n",x,"\n")}

// send an answer
sendans:{
 receiveanswer::0b;
 (neg handles`handle)@\:({-1"\nAnswers received to question ",string[y],":\n\n"; show x;-1"\n"};select last a by u from answers where n=currentquestion;currentquestion)}

// close client processes on exit
.z.exit:{@[;"-1\"Thanks for playing!\n\nNOW GET BACK TO WORK\n\n\"; exit 0";0] each handles`handle}

q:sendquestion
a:sendans

//auto-ask questions on timer
qus:ssr[;"\\n";"\n"] each read0 hsym`$.z.x 0
start:{system"t 45000"}
.z.ts:{if[not count qus;system"t 0";a[];.z.exit[];system"p 0"];if[receiveanswer;a[]];q first qus;qus::1_qus}

//marking
mrk:{[x;y]
  show r:`t xasc `id`a xcols 0!update id:i from select by u from x where n=y;
  1"IDs for right answers: ";
  ids:"I"$" "vs read0 0;
  im:ids!3,(count[ids]-1)#2;
  ti:select s:last im id by u,t from r;
  :x lj ti;
 }
mark:{marked::mrk/[x;exec distinct n from x];marked}

score:{`scores set `ts xdesc select ts:sum s,f:count i where s=3 by u from x;scores};
