-module(day03).

-export([read_lines/0]).

read_lines() ->
  {ok, FD} = file:open("day03-input.txt", [read]),
  print_lines(FD).

print_lines(FD) ->
  case io:get_line(FD, "") of
    eof ->
      io:format("~n"),
      file:close(FD);
    Line ->
        io:format("~s", [Line]),
        print_line(FD)
  end.