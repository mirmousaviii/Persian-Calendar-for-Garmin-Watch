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
    mainText = (new PersianCalendarApp()).getJalaliDateStr();
  }

  function onUpdate(dc as Graphics.Dc) as Void {
    if (mainText != null) {
      dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        0,
        dc.getHeight() / 2 - Graphics.getFontHeight(Graphics.FONT_MEDIUM) / 2,
        Graphics.FONT_MEDIUM,
        mainText as String,
        Graphics.TEXT_JUSTIFY_LEFT
      );
    }
  }
}
