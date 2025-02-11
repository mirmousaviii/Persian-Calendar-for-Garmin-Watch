using Toybox.WatchUi as Ui;
using Toybox.Time.Gregorian;
using Toybox.Time;
using Toybox.Graphics as Gfx;
using Toybox.System;
using Toybox.Math;

class PersianCalendarView extends Ui.View {
    // Display properties
    var font = Gfx.FONT_XTINY;
    var lineSpacing = Gfx.getFontHeight(Gfx.FONT_XTINY) + 2;
    var centerY = 60;
    var centerX = 60;
    var xSpacing = 30;

    // Currently displayed month and year in the calendar
    var currentMonthView = 1;
    var currentYearView = 1400;

    // Instance of PersianCalendarApp (created only once)
    var persianCalendarApp;
    var isGregorian = false;

    // Initialization method (called once)
    function initialize() {
        View.initialize();
        persianCalendarApp = new PersianCalendarApp();

        // Initialize calendar based on today's Gregorian date converted to Jalali
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var result = persianCalendarApp.gregorianToJalali(today.year, today.month, today.day);
        currentMonthView = result.get("month");
        currentYearView = result.get("year");
    }

    // Layout setup when the view size is determined
    function onLayout(dc) {
        centerY = (dc.getHeight() / 2) - (lineSpacing / 2) - 70;
        centerX = (dc.getWidth() / 2) - (2 * Gfx.getFontHeight(font));
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    function onShow() {
        // Optional: Additional code when the view is shown can be added here
    }

    // Called to update the display
    function onUpdate(dc) {
        font = Gfx.FONT_XTINY;
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();

        // Get today's Gregorian date and convert it to Jalali for highlighting
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var todayJalali = persianCalendarApp.gregorianToJalali(today.year, today.month, today.day);
        var currentMonth = todayJalali.get("month");
        var currentYear = todayJalali.get("year");

        // Draw the month and year as a header at the top of the screen if not in the current month view
        if (currentMonthView != currentMonth || currentYearView != currentYear) {
            var monthNames = ["Far.", "Ord.", "Kho.", "Tir.", "Mor.", "Sha.", "Meh.", "Aba.", "Aza.", "Dey.", "Bah.", "Esf."];
            var headerText = monthNames[currentMonthView - 1] + " " + currentYearView.toString();
            dc.setColor(Gfx.COLOR_DK_GREEN, Gfx.COLOR_TRANSPARENT);
            dc.drawText(centerX, centerY - lineSpacing - 5, font, headerText, Gfx.TEXT_JUSTIFY_LEFT);
        } else {
            // Draw the date string as a header at the top of the screen
            dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
            var dateStr = isGregorian ? persianCalendarApp.getGregorianDateStr() : persianCalendarApp.getJalaliDateStr();
            dc.drawText(centerX, centerY - lineSpacing - 5, font, dateStr, Gfx.TEXT_JUSTIFY_LEFT);
        }

        drawMonthTable(dc, currentMonthView, currentYearView, currentMonth, todayJalali.get("day"));

    }

    // Draws the calendar month table
    public function drawMonthTable(dc, viewMonth, viewYear, currentMonth, currentDay) {
        var marginLeft = 15;
        var startX = Math.round(dc.getWidth() / 9.0) + marginLeft;
        var startY = 30;
        var ySpacing = lineSpacing;

        // Draw weekday header
        var weekDays = ['S', 'S', 'M', 'T', 'W', 'T', 'F'];
        var xPos = startX;
        for (var i = 0; i < weekDays.size(); i++) {
            // Set color based on device dimensions
            if (dc.getWidth() == 208 && dc.getHeight() == 208) {
                dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
            } else {
                dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
            }
            dc.drawText(xPos, centerY - lineSpacing + startY, font, weekDays[i].toString(), Gfx.TEXT_JUSTIFY_CENTER);
            xPos += Math.round(dc.getWidth() / 9.0) + 1;
        }

        // Draw calendar days
        var dayIterator = 1;
        var weekDay = get_week_day(viewMonth, viewYear);
        if (weekDay == 7) { // Adjust if weekDay equals 7
            weekDay = 0;
        }
        var monthDays = get_month_days(viewMonth);

        var yPos = startY + ySpacing;

        while (dayIterator <= monthDays) {
            xPos = startX;
            for (var i = 0; i < 7; i++) {
                if (dayIterator != 1 || weekDay == i) {
                    // Highlight the current day in blue
                    if (viewMonth == currentMonth && dayIterator == currentDay) {
                        dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
                    // Normal color for Gregorian dates
                    } else if(isGregorian) {
                        dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
                    } else {
                        // Different color for last column
                        if (i == 6) {
                            dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_TRANSPARENT);
                        // Normal color for other cells
                        } else {
                            dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
                        }
                    }

                    var dateText = isGregorian ? persianCalendarApp.jalaliToGregorian(viewYear, viewMonth, dayIterator).get("day").toString() : dayIterator.toString();
                    dc.drawText(xPos, centerY - lineSpacing + yPos, font, dateText, Gfx.TEXT_JUSTIFY_CENTER);
                    dayIterator++;
                    if (dayIterator > monthDays) {
                        break;
                    }
                }
                xPos += Math.round(dc.getWidth() / 9.0) + 1;
            }
            yPos += ySpacing;
        }
    }

    // Toggle display mode between Gregorian and Jalali dates
    public function toggleDisplayMode() {
        isGregorian = !isGregorian;
        Ui.requestUpdate();
    }

    public function showPreviousMonth() {
        if (currentMonthView == 1) {
            currentMonthView = 12;
            currentYearView--;
        } else {
            currentMonthView--;
        }
        Ui.requestUpdate();
    }

    public function showNextMonth() {
        if (currentMonthView == 12) {
            currentMonthView = 1;
            currentYearView++;
        } else {
            currentMonthView++;
        }
        Ui.requestUpdate();
    }

    function onHide() {
        // Optional: Clean up resources here if needed
    }
}

// Helper function to get the number of days in a month (for months 1-12)
function get_month_days(month) {
    var monthDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (month >= 1 && month <= 12) {
        return monthDays[month - 1];
    }
    return 0;
}

// Helper function to calculate the weekday of the first day of the given Jalali month/year
function get_week_day(month, year) {
    var gregorian = (new PersianCalendarApp()).jalaliToGregorian(year, month, 1);
    var options = {
        :year  => gregorian.get("year"),
        :month => gregorian.get("month"),
        :day   => gregorian.get("day")
    };
    var date = Gregorian.moment(options);
    var firstDayInfo = Gregorian.info(date, Time.FORMAT_SHORT);
    return firstDayInfo.day_of_week;
}
