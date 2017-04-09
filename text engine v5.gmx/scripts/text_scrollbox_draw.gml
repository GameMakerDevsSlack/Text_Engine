///text_scrollbox_draw( x, y, scrollbox json, text json )

var _x           = argument0;
var _y           = argument1;
var _scroll_json = argument2;
var _text_json   = argument3;

var _old_colour = draw_get_colour();

var _width            = _scroll_json[? "width"            ];
var _height           = _scroll_json[? "height"           ];
var _scrollbar_width  = _scroll_json[? "scrollbar width"  ];
var _scrollbar_height = _scroll_json[? "scrollbar height" ];
var _surface          = _scroll_json[? "surface"          ];

var _scrollbar_left   = _scroll_json[? "scrollbar left"   ];
var _scrollbar_top    = _scroll_json[? "scrollbar top"    ];
var _scrollbar_right  = _scroll_json[? "scrollbar right"  ];
var _scrollbar_bottom = _scroll_json[? "scrollbar bottom" ];
var _scrollbar_t      = _scroll_json[? "scrollbar t"      ];
var _scrollbar_down   = _scroll_json[? "scrollbar down"   ];

var _scroll_distance = max( 0, _text_json[? "height" ] - _height );

if ( !surface_exists( _surface ) ) {
    _surface = surface_create( _width, _height );
    _scroll_json[? "surface" ] = _surface;
}

if ( !surface_exists( _surface ) ) exit;

var _text_offset_x = -_text_json[? "left" ];
var _text_offset_y = -_text_json[? "top"  ];

surface_set_target( _surface );
    
    draw_rectangle( 0, 0, _width, _height, false );
    text_draw( _text_offset_x, _text_offset_y - _scrollbar_t * _scroll_distance, _text_json, false );
    
    draw_set_colour( c_red );
    draw_rectangle( _width - _scrollbar_width, 0, _width, _height, false );
    
    if ( _scroll_json[? "scrollbar down" ] ) draw_set_colour( merge_colour( c_yellow, c_white, 0.5 ) ) else draw_set_colour( c_yellow );
    var _scrollbar_y = 0;
    var _scrollbar_max_y = _height - _scrollbar_height;
    _scrollbar_y = lerp( 0, _scrollbar_max_y, _scrollbar_t );
    
    draw_rectangle( _scrollbar_left, _scrollbar_top, _scrollbar_right, _scrollbar_bottom, false );
    
surface_reset_target();

draw_surface( _surface, _x, _y );
draw_set_colour( _old_colour );