/*
 * =====================================================================================
 *
 *       Filename:  jquery-notetime.js
 *
 *    Description:  jquery plugin for updating note time
 *
 *        Version:  1.0
 *        Created:  2012年02月29日 18时06分44秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *        Company:  
 *
 * =====================================================================================
*/

(function($) {

  "use strict"

  var TimeUpdater = function ( element ) {
      this.element = $(element);
  }

  TimeUpdater.prototype = {
      constructor: TimeUpdater
      , updateTime: function () {
          var getTime = function(date) {
              return {
                  year: date.getFullYear(),
                  month: date.getMonth()+1,
                  //day: date.getDay(), //星期
                  day: date.getDate(), //日
                  hour: date.getHours(),
                  minute: date.getMinutes(),
                  second: date.getSeconds(),
              };
          };

          var now = getTime(new Date());

          var $time = $(this.element);
          var creation, a, b, c;

          var creation = getTime(new Date($time.attr('data')));
          if ($.browser.mozilla) {
              creation = getTime(new Date($time.attr('data').replace(/-/g, '/')));
          } else {
              creation = getTime(new Date($time.attr('data')));
          }

          if (now.year == creation.year) {
              if (now.year == creation.year && now.month == creation.month && 
                  now.day == creation.day) {
                  if (now.hour == creation.hour) {
                      if (now.minute == creation.minute) {
                          a = now.second - creation.second;
                          $time.html(a+"秒前");
                      } else {
                          b = now.minute - creation.minute;
                          $time.html(b+"分钟前");
                      }
                  } else if (now.hour - creation.hour == 1 && creation.minute > now.minute  ) {
                      $time.html(now.minute+60-creation.minute+"分钟前");
                  } else {
                      c = now.hour - creation.hour;
                      $time.html(c+"小时前");
                  }
              } else {
                  $time.html(creation.month+"月"+creation.day+"日"+creation.hour+":"+creation.minute);
              }
          } else {
              $time.html(creation.year+"年"+creation.month+"月"+creation.day+"日"+creation.hour+":"+creation.minute);
          }
      }
  };

  $.fn.updateNoteTime = function () {
      return this.each(function () {
          var $this = $(this)
          , data = $this.data('noteTime')
          if (!data) 
              $this.data('noteTime', (data = new TimeUpdater(this)));
          data.updateTime();
      })
  };
  $.fn.updateNoteTime.Constructor = TimeUpdater;

})(jQuery);
