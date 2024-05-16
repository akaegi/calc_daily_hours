import 'dart:io';

int main() {
  stdout.writeln('Please enter your daily ours in the following format:');
  stdout.writeln('6:20-7:05, 8:15-12, 13-16:20, 16:40-17');

  while (true) {
    stdout.writeln();
    stdout.write('> ');
    var input = stdin.readLineSync()?.toLowerCase();
    if (input == "exit" || input == 'quit') return 0;

    if (input != null && input != '') {
      try {
        _processInput(input);
      } catch (e) {
        stdout.writeln(e);
      }
    }
  }
}

void _processInput(String input) {
  var timeBlocks = input.split(',');

  var durations = timeBlocks.map((b) {
    var fromTo = b.trim().split('-');
    if (fromTo.length != 2) throw Exception('Malformed time block: ${b}');

    var now = DateTime.now();
    var from = _parseTime(now, fromTo[0]);
    var to = _parseTime(now, fromTo[1]);

    return to.difference(from);
  }).toList();

  var durationSumFormatted = durations.map(_formatDuration).join('+');

  var totalDuration = durations.reduce((acc, d) => acc + d);
  var totalDurationFormatted = _formatDuration(totalDuration);

  stdout.writeln('${input} = ${durationSumFormatted} = ${totalDurationFormatted}');
}

DateTime _parseTime(DateTime day, String timeString) {
  var regex = RegExp(r'^([0-9]+):?([0-9]*$)');
  RegExpMatch? match = regex.firstMatch(timeString);
  if (match == null) throw Exception('Invalid time string ${timeString}');

  var hh = match[1]!.padLeft(2, '0');
  var mm = match[2]?.padLeft(2, '0') ?? '00';

  var dateTimeString = '${_formatDateTime(day)} ${hh}:${mm}';
  return DateTime.parse(dateTimeString);
}

String _formatDateTime(DateTime dt) {
  var yyyy = dt.year;
  var mm = dt.month.toString().padLeft(2, '0');
  var dd = dt.day.toString().padLeft(2, '0');
  return '${yyyy}-${mm}-${dd}';
}

String _formatDuration(Duration d) {
  var hh = d.inHours.toString().padLeft(2, '0');
  var mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  return '${hh}:${mm}';
}
