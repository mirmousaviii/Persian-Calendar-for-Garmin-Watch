import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

(:glance)
class PersianCalendarGlanceView extends WatchUi.GlanceView {
  var jalaliText as String?;
  var gregorianText as String?;

  function initialize() {
    GlanceView.initialize();
  }

  function onLayout(dc as Graphics.Dc) as Void {
    jalaliText = (new PersianCalendarApp()).getJalaliDateStr();
    gregorianText = (new PersianCalendarApp()).getGregorianDateStr();
  }

  function onUpdate(dc as Graphics.Dc) as Void {
    var textHeight = Graphics.getFontHeight(Graphics.FONT_MEDIUM);
    var startY = (dc.getHeight() / 2) - textHeight;

    if (jalaliText != null && gregorianText != null) {
      dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
          0,
          startY,
          Graphics.FONT_MEDIUM,
          new PersianCalendarApp().getJalaliDateStr(),
          Graphics.TEXT_JUSTIFY_LEFT
      );

      dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
          0,
          startY + textHeight,
          Graphics.FONT_TINY,
          new PersianCalendarApp().getGregorianDateStr(),
          Graphics.TEXT_JUSTIFY_LEFT
      );
    }
  }
}
