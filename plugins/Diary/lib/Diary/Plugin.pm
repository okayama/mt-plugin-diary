package Diary::Plugin;
use strict;

use MT::Util qw( offset_time_list format_ts );

sub _cb_tp_edit_entry {
    my ( $cb, $app, $param, $tmpl ) = @_;
    if ( my $blog = $app->blog ) {
        my $plugin = MT->component( 'Diary' );
        my $blog_id = $blog->id;
        my $scope = 'blog:' . $blog_id;
        return unless $plugin->get_config_value( 'is_active', 'blog:' . $blog_id );
        if ( ! $app->param( 'id' ) && ! $app->param( 'reedit' ) && ! $app->param( 'title' ) ) {
            my @tl = offset_time_list( time, $blog );
            my $title = sprintf "%04d-%02d-%02d", $tl[ 5 ] + 1900, $tl[ 4 ] + 1, @tl[ 3, 2, 1, 0 ];
            my $redirect_url = $app->base . $app->uri( mode => 'view',
                                                       args => {
                                                           _type => $app->param( '_type' ),
                                                           blog_id => $blog_id,
                                                           title => $title,
                                                       },
                                                     );
            return $app->redirect( $redirect_url );
        }
    }
}

1;
