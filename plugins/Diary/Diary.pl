package MT::Plugin::Diary;
use strict;
use MT;
use MT::Plugin;
use base qw( MT::Plugin );

our $PLUGIN_NAME = 'Diary';
our $PLUGIN_VERSION = '1.0';

my $plugin = new MT::Plugin::Diary( {
    id => $PLUGIN_NAME,
    key => lc $PLUGIN_NAME,
    name => $PLUGIN_NAME,
    version => $PLUGIN_VERSION,
    description => "<MT_TRANS phrase='Utility for creating entry for diary.'>",
    author_name => 'okayama',
    author_link => 'http://weeeblog.net/',
    l10n_class => 'MT::' . $PLUGIN_NAME . '::L10N',
	blog_config_template => \&_blog_config_template,
    settings => new MT::PluginSettings( [
        [ 'is_active', { Default => '', Scope => 'blog' } ],
    ] ),
} );
MT->add_plugin( $plugin );

sub init_registry {
    my $plugin = shift;
    $plugin->registry( {
        callbacks => {
            'MT::App::CMS::template_param.edit_entry' => 'MT::' . $PLUGIN_NAME . '::Plugin::_cb_tp_edit_entry',
        },
    } );
}

sub _blog_config_template {
	my $plugin = shift;
	my ( $param,  $scope ) = @_;
	my $tmpl = $plugin->load_tmpl( lc $PLUGIN_NAME . '_config_blog.tmpl' );
	my $blog_id = $scope;
	$blog_id =~ s/blog://;
	$tmpl->param( 'blog_id' => $blog_id );
	my $app = MT->instance;
	$tmpl->param( 'mt_url' => $app->base . $app->uri );
	return $tmpl; 
}

1;
