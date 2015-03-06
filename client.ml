let nsub = 5
let size = 5
let n = nsub * size
let m = "5\n"
let nl () = output_char '\n'
let int_of_str s =
  let rec go i x =
    if i < String.length s && '0' <= s.[i] && s.[i] <= '9' then
      go (i+1) (x * 10 + Obj.magic s.[i] - 48)
    else
      x
  in
  go 0 0

let r = Array.make n [||]
let d = Array.make n [||]
let e = Array.make n [||];;

let reed_muller_transform a =
  for ldm = 10 downto 1 do
    let m = 1 lsl ldm in
    let mh = m lsr 1 in
    let rec go i j =
      if j = mh then
        go (i+m) 0
      else if i < 1024 then (
        a.(i+j+mh) <- a.(i+j) lxor a.(i+j+mh);
        go i (j+1)
      )
    in
    go 0 0
  done

let fetch e =
  let a = Array.make 1024 0 in
  for i = 0 to 1023 do
    a.(i) <- if recv_char() = '0' then 0 else 1
  done;
  reed_muller_transform a;
  for x = 0 to n-1 do
    e.(x) <- Array.make n true;
    for y = 0 to n-1 do
      e.(x).(y) <- a.(x*n+y) <> 0
    done;
  done;;

(*let output_char = output_char stdout;;*)
(*let output_string = output_string stdout;;*)

output_string "Sample:\n";;
output_string ".@._._._.\n";
output_string "|_. |_. |\n";
output_string "| |_. | |\n";
output_string "| . |_. |\n";
output_string "|_|_._. |\n";
output_string "       $ \n";;
output_string "You need to input: drdrdrdd\n";

send_string m;

(*for x = 0 to n-1 do*)
  (*r.(x) <- Array.make n false;*)
  (*d.(x) <- Array.make n false;*)
  (*e.(x) <- Array.make n true;*)
  (*for y = 0 to n-1 do*)
    (*r.(x).(y) <- recv_char() <> '0';*)
  (*done;*)
  (*for y = 0 to n-1 do*)
    (*d.(x).(y) <- recv_char() <> '0';*)
  (*done;*)
  (*for y = 0 to n-1 do*)
    (*e.(x).(y) <- recv_char() <> '0';*)
  (*done*)
(*done;*)
fetch r;
fetch d;
fetch e;

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
let cnt () =
  let rec go s x y =
    if y = n then
      go s (x+1) 0
    else if x = n then
      s
    else
      go (if e.(x).(y) then s+1 else s) x (y+1)
  in
  go 0 0 0
in
if cnt() <> int_of_str m * nsub * nsub then (
  output_string "I find your trick... I'm tamper-resistant!";
  let _ = 0/0 in ()
);

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
