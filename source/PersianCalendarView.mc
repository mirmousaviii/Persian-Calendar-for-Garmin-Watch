using Toybox.WatchUi as Ui;
using Toybox.Time.Gregorian;
using Toybox.Time;
using Toybox.Graphics as Gfx;
using Toybox.System;
using Toybox.Math;

class PersianCalendarView extends Ui.View {
  var font = Gfx.FONT_XTINY;
  var lineSpacing = Gfx.getFontHeight(font) + 2;

  var centerY = 60;
  var centerX = 60;

  var X_Spacing = 30;

  function initialize() {
    View.initialize();

    var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    var result = (new PersianCalendarApp()).gregorianToJalali(
      today.year,
      today.month,
      today.day
    );

    current_month_view = result.get("month");
    current_year_view = result.get("year");
  }

  function onLayout(dc) {
    centerY = dc.getHeight() / 2 - lineSpacing / 2;
    centerY -= 70;
    centerX = dc.getWidth() / 2 - 2 * Gfx.getFontHeight(font);
    setLayout(Rez.Layouts.MainLayout(dc));
  }

  function onShow() {}

  function onUpdate(dc) {
    if (show_today) {
      font = Gfx.FONT_XTINY;

      dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
      dc.clear();
      dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
      var jalali = (new PersianCalendarApp()).getJalaliDateStr();
      dc.drawText(
        centerX,
        centerY - 1 * lineSpacing,
        font,
        jalali,
        Gfx.TEXT_JUSTIFY_LEFT
      );
    } else {
      dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
      dc.clear();
      dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
      var current_view_text =
        get_month_string(current_month_view) + "-" + current_year_view;
      dc.drawText(
        centerX + 10,
        centerY - 1 * lineSpacing,
        font,
        current_view_text,
        Gfx.TEXT_JUSTIFY_LEFT
      );
      dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
    }

    var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    var result = (new PersianCalendarApp()).gregorianToJalali(
      today.year,
      today.month,
      today.day
    );

    drawMonthTable(
      dc,
      current_month_view,
      current_year_view,
      result.get("month"),
      result.get("day")
    );
  }

  public function drawMonthTable(dc, month, year, current_month, current_day) {
    var my_x;
    var my_y = 20;
    var i = 0;

    font = Gfx.FONT_XTINY;

    X_Spacing = Math.round(dc.getWidth() / 9.0) + 1;
    var Y_Spacing = lineSpacing;
    System.println("lineSpacing");
    System.println(lineSpacing);

    // Draw the calendar header table
    my_x = Math.round(dc.getWidth() / 9.0);
    my_y = my_y + Y_Spacing;
    var week = ['S', 'S', 'M', 'T', 'W', 'T', 'F'];
    for (i = 0; i < 7; i++) {
      dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
      dc.drawText(
        my_x,
        centerY - 1 * lineSpacing + my_y,
        font,
        week[i].toString(),
        Gfx.TEXT_JUSTIFY_LEFT
      );
      my_x += X_Spacing;
    }

    // Draw the calendar month table
    my_y = my_y + Y_Spacing;
    my_x = Math.round(dc.getWidth() / 9.0);
    var iterator = 1;

    var week_day = get_week_day(month, year);

    if (week_day == 7) {
      week_day = 0;
    } //set Saturday to 0
    var month_days = get_month_days(month);

    while (iterator <= month_days) {
      for (i = 0; i < 7; i++) {
        if (i == 6) {
          dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_TRANSPARENT);
        }
        if (
          month == current_month and
          iterator == current_day and
          current_month != 0
        ) {
          dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
        }

        if (iterator != 1 || week_day == i) {
          dc.drawText(
            my_x,
            centerY - 1 * lineSpacing + my_y,
            font,
            iterator.toString(),
            Gfx.TEXT_JUSTIFY_LEFT
          );
          iterator += 1;
          if (iterator > month_days) {
            break;
          }
        }
        my_x += X_Spacing;

        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      }
      my_y = my_y + Y_Spacing;
      my_x = Math.round(dc.getWidth() / 9.0);
    }
  }
  function onHide() {}
}

var current_month_view = 1;
var current_year_view = 1400;
var show_today = true;

function updateTable(reset) {
  if (reset) {
    var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    var result = (new PersianCalendarApp()).gregorianToJalali(
      today.year,
      today.month,
      today.day
    );

    current_month_view = result.get("month");
    current_year_view = result.get("year");
    show_today = true;
  } else {
    show_today = false;
  }
  Ui.requestUpdate();
  return true;
}

//public functions
function div(a, b) {
  return a / b;
}


function get_month_days(month) {
  switch (month) {
    case 1:
      return 31;
    case 2:
      // This will return 28 by default for February. 
      // To handle leap years, additional logic would be needed.
      return 28; 
    case 3:
      return 31;
    case 4:
      return 30;
    case 5:
      return 31;
    case 6:
      return 30;
    case 7:
      return 31;
    case 8:
      return 31;
    case 9:
      return 30;
    case 10:
      return 31;
    case 11:
      return 30;
    case 12:
      return 31;
    default:
      // You might want to handle invalid month numbers.
      return null;
  }
}

function get_month_string(month) {
  switch (month) {
    case 1:
      return "Farv";
    case 2:
      return "Ordi";
    case 3:
      return "Khor";
    case 4:
      return "Tir";
    case 5:
      return "Mor";
    case 6:
      return "Shah";
    case 7:
      return "Mehr";
    case 8:
      return "Aban";
    case 9:
      return "Azar";
    case 10:
      return "Dei";
    case 11:
      return "Bahm";
    case 12:
      return "Esfa";
    default:
      return "Invalid month";  // Handling the case where the month is out of range
  }
}

function get_week_day(month, year) {
  var gregorian = (new PersianCalendarApp()).jalaliToGregorian(year, month, 1);

  var options = {
    :year => gregorian.get("year"),
    :month => gregorian.get("month"),
    :day => gregorian.get("day"),
  };
  var date = Gregorian.moment(options);
  var first_day = Gregorian.info(date, Time.FORMAT_SHORT);
  return first_day.day_of_week;
}
