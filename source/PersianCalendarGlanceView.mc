import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

(:glance)
class PersianCalendarGlanceView extends WatchUi.GlanceView {
  var mainText as String?;

  function initialize() {
    GlanceView.initialize();
  }

  function onLayout(dc as Graphics.Dc) as Void {
    mainText = (
      (new PersianCalendarApp()).getGregorianDateStr() +
      "\n" +
      (new PersianCalendarApp()).getJalaliDateStr()
    );
  }

  function onUpdate(dc as Graphics.Dc) as Void {
    if (mainText != null) {
      dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        0,
        dc.getHeight() / 4 - Graphics.getFontHeight(Graphics.FONT_SMALL) / 4,
        Graphics.FONT_SMALL,
        mainText as String,
        Graphics.TEXT_JUSTIFY_LEFT
      );
    }
  }
}
