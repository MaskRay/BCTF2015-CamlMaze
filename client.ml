let nsub = 5;;
let size = 5;;
let n = nsub * size;;

(*let output_char = output_char stdout;;*)
(*let output_string = output_string stdout;;*)

output_string "Sample:\n";;
output_string ".@._._._.\n";
output_string "|_. |_. |\n";
output_string "| |_. | |\n";
output_string "| . |_. |\n";
output_string "|_|_._. |\n";
output_string "       $ \n";;
output_string "You need to input: drdrdrdd\n";;

let nl () = output_char '\n';;

send_string "5\n";;

let r = Array.make n [||];;
let d = Array.make n [||];;
let e = Array.make n [||];;

for x = 0 to n-1 do
  r.(x) <- Array.make n false;
  d.(x) <- Array.make n false;
  e.(x) <- Array.make n true;
  for y = 0 to n-1 do
    r.(x).(y) <- recv_char() <> '0';
  done;
  for y = 0 to n-1 do
    d.(x).(y) <- recv_char() <> '0';
  done;
  for y = 0 to n-1 do
    e.(x).(y) <- recv_char() <> '0';
  done
done;


output_string "\nChallenge:\n";;
for x = 0 to n-1 do
  output_char (
    if e.(0).(x) || x > 0 && e.(0).(x-1) then
      '.'
    else
    ' ');
  output_char (
    if e.(0).(x) then
      if x > 0 then '_' else '@'
    else
      ' ');
done;
output_char (if e.(0).(n-1) then '.' else ' ');
nl();

for x = 0 to n-1 do
  output_char (if e.(x).(0) || e.(x).(1) then '|' else ' ');
  for y = 0 to n-1 do
    output_char (if e.(x).(y) then
                   if d.(x).(y) then ' ' else '_'
                 else if x+1 < n then
                   if e.(x+1).(y) then
                     if d.(x).(y) then ' ' else '_'
                   else
                     '#'
                 else
                   '#'
                );
    output_char (if e.(x).(y) then
                   if r.(x).(y) then '.' else '|'
                 else if y+1 < n then
                   if e.(x).(y+1) then
                     if r.(x).(y) then '.' else '|'
                   else
                     '#'
                 else
                   '#'
                );
  done;
  output_char '\n'
done;
for i = 0 to 2*n-2 do
  output_char ' '
done;
output_char '$';

output_string "\nHint: you need to see more to escape\n";;
output_string "\nPath?\n";;

let buf = String.make 100000 '.' in
let rec read i =
  let c = input_char() in
  if c = 'u' || c = 'r' || c = 'l' || c = 'd' then (
    buf.[i] <- c;
    read (i+1)
  ) else (
    output_string "\nI Will send ";
    output_int i;
    output_string " actions: ";
    let s = String.make (i+1) '.' in
    for j = 0 to i-1 do
      s.[j] <- buf.[j]
    done;
    s.[i] <- '\n';
    output_string s;
    output_char '\n';
    s
  )
in

let s = read 0 in
send_string s;

let rec read () =
  let c = recv_char() in
  output_char c;
  if c <> '\n' then
    read()
in
read()
