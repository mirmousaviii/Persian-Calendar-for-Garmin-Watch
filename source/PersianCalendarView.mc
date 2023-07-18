import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Time.Gregorian;


class PersianCalendarView extends WatchUi.View {

    hidden var dateText;


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


    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);

        var jalali = gregorian_to_jalali(today.year, today.month, today.day);
        var jalaliStr = jalali.get("year").toString() + "/" + jalali.get("month").toString() + "/" + jalali.get("day").toString();



        dateText = new WatchUi.Text({
            :text=>jalaliStr,
            :color=>Graphics.COLOR_PINK,
            :font=>Graphics.FONT_LARGE,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_CENTER
        });
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        // View.onUpdate(dc);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dateText.draw(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
