import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Time.Gregorian;

class PersianCalendarApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new PersianCalendarView() ] as Array<Views or InputDelegates>;
    }

    function getGlanceView() as Array<GlanceView>? {
        return [new PersianCalendarGlanceView()] as Array<GlanceView>;
    }

    function gregorian_to_jalali(gy, gm, gd) {
        var days;
        var gy2 = (gm > 2) ? (gy + 1) : gy;
        var g_d_m = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
        days = 355666 + (365 * gy) + ((gy2 + 3) / 4).toNumber() - ((gy2 + 99) / 100).toNumber() + ((gy2 + 399) / 400).toNumber() + gd + g_d_m[gm - 1];
        
        var jy = -1595 + (33 * (days / 12053).toNumber());
        days %= 12053;
        jy += 4 * (days / 1461).toNumber();
        days %= 1461;
        if (days > 365) {
            jy += ((days - 1) / 365).toNumber();
            days = (days - 1) % 365;
        }

        var jalaliObject = {
            "year"=> 0,
            "month"=> 0,
            "day"=> 0
        };
        jalaliObject.put("year", jy);
        if (days < 186) {
            jalaliObject.put("month", 1 + (days / 31).toNumber());
            jalaliObject.put("day", 1 + (days % 31));
        } else {
            jalaliObject.put("month", 7 + ((days - 186) / 30).toNumber());
            jalaliObject.put("day", 1 + ((days - 186) % 30));
        }
        return jalaliObject;
    }

    function getJalaliDateStr() {
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);

        var jalali = gregorian_to_jalali(today.year, today.month, today.day);
        var jalaliStr = jalali.get("year").toString() + "/" + jalali.get("month").toString() + "/" + jalali.get("day").toString();

        return jalaliStr;
    }

}

function getApp() as PersianCalendarApp {
    return Application.getApp() as PersianCalendarApp;
}