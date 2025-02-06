using Toybox.WatchUi as Ui;

class PersianCalendarDelegate extends Ui.InputDelegate {
    var view as PersianCalendarView;

    function initialize(viewInstance as PersianCalendarView) {
        Ui.InputDelegate.initialize();
        view = viewInstance;
    }

    function onTap(clickEvent as Ui.ClickEvent) {
        view.toggleDisplayMode();
        return true;
    }

//   function onTap(clickEvent as Ui.ClickEvent) {
//     System.println(clickEvent.getType().toString()); // e.g. CLICK_TYPE_TAP = 0
//     return true;
//   }

//   function onKey(keyEvent) {
//     System.println(keyEvent.getKey().toString()); // e.g. KEY_MENU = 7
//     return true;
//   }

//   function onSwipe(swipeEvent) {
//     System.println(swipeEvent.getDirection().toString()); // e.g. SWIPE_DOWN = 2
//     return true;
//   }
}
