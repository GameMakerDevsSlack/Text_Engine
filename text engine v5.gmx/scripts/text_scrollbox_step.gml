///text_scrollbox_step( x, y, scrollbox json, text json, mouse x, mouse y )

var _x           = argument0;
var _y           = argument1;
var _scroll_json = argument2;
var _text_json   = argument3;
var _mouse_x     = argument4;
var _mouse_y     = argument5;

var _old_colour = draw_get_colour();

var _width            = _scroll_json[? "width"            ];
var _height           = _scroll_json[? "height"           ];
var _scrollbar_width  = _scroll_json[? "scrollbar width"  ];
var _scrollbar_height = _scroll_json[? "scrollbar height" ];
var _surface          = _scroll_json[? "surface"          ];

var _scrollbar_left   = _scroll_json[? "scrollbar left"   ] + _x;
var _scrollbar_top    = _scroll_json[? "scrollbar top"    ] + _y;
var _scrollbar_right  = _scroll_json[? "scrollbar right"  ] + _x;
var _scrollbar_bottom = _scroll_json[? "scrollbar bottom" ] + _y;
var _scrollbar_t      = _scroll_json[? "scrollbar t"      ];
var _scrollbar_down   = _scroll_json[? "scrollbar down"   ];
var _scrollbar_down_y = _scroll_json[? "scrollbar down y" ];

var _scrollbar_over = point_in_rectangle( _mouse_x, _mouse_y,   _scrollbar_left, _scrollbar_top, _scrollbar_right, _scrollbar_bottom );
_scroll_json[? "scrollbar over" ] = _scrollbar_over;

if ( _scrollbar_over ) {
    if ( mouse_check_button( mb_left ) ) and ( !_scrollbar_down ) {
        _scrollbar_down = true;
        _scrollbar_down_y = _mouse_y - _scrollbar_top;
        _scroll_json[? "scrollbar down y" ] = _scrollbar_down_y;
    } else if ( !mouse_check_button( mb_left ) ) {
        _scrollbar_down = false;
    }
}

if ( !mouse_check_button( mb_left ) ) _scrollbar_down = false;
_scroll_json[? "scrollbar down" ] = _scrollbar_down;

if ( _scrollbar_down ) {
    var _scrollbar_y = clamp( _mouse_y - _scrollbar_down_y - _y, 0, _height - _scrollbar_height );
    _scroll_json[? "scrollbar top"    ] = _scrollbar_y;
    _scroll_json[? "scrollbar bottom" ] = _scrollbar_y + _scrollbar_height;
    _scroll_json[? "scrollbar t"      ] = clamp( _scrollbar_y / ( _height - _scrollbar_height ), 0, 1 );
}
