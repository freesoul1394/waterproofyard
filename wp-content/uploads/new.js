function PbStyleQuantite(a) {
    var b, c = !1;
    a || (a = ".qty"),
    b = jQuery("div.quantity:not(.buttons_added), td.quantity:not(.buttons_added)").find(a),
    b.length && (jQuery.each(b, function(a, b) {
        "date" !== jQuery(b).prop("type") && "hidden" !== jQuery(b).prop("type") && (jQuery(b).parent().hasClass("buttons_added") || (jQuery(b).parent().addClass("buttons_added").prepend('<input type="button" value="-" class="minus" />'),
        jQuery(b).addClass("input-text").after('<input type="button" value="+" class="plus" />'),
        c = !0))
    }),
    c && (jQuery("input" + a + ":not(.product-quantity input" + a + ")").each(function() {
        var a = parseFloat(jQuery(this).attr("min"));
        a && a > 0 && parseFloat(jQuery(this).val()) < a && jQuery(this).val(a)
    }),
    jQuery(".plus, .minus").unbind("click"),
    jQuery(".plus, .minus").on("click", function() {
        var b = jQuery(this).parent().find(a)
          , c = parseFloat(b.val())
          , d = parseFloat(b.attr("max"))
          , e = parseFloat(b.attr("min"))
          , f = b.attr("step");
        c && "" !== c && "NaN" !== c || (c = 0),
        "" !== d && "NaN" !== d || (d = ""),
        "" !== e && "NaN" !== e || (e = 0),
        "any" !== f && "" !== f && void 0 !== f && "NaN" !== parseFloat(f) || (f = 1),
        jQuery(this).is(".plus") ? d && (d == c || c > d) ? b.val(d) : b.val(c + parseFloat(f)) : e && (e == c || c < e) ? b.val(e) : c > 0 && b.val(c - parseFloat(f)),
        b.trigger("change")
    })))
}
jQuery(window).on("load", function() {
    PbStyleQuantite()
}),
jQuery(document).ajaxComplete(function() {
    PbStyleQuantite()
});