package TestApp::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }
with 'Catalyst::TraitFor::Controller::reCAPTCHA';

__PACKAGE__->config->{namespace} = '';

sub default :Path { 
    my ( $self, $c ) = @_; 

    $c->forward('captcha_get');

    my $body =
        '<html><body><p>recaptcha error: '. 
        ($c->stash->{recaptcha_ok} || '') . " " . 
        ($c->stash->{recaptcha_error} || '') . 
        '</p><form name="recaptcha" action="'. 
        $c->uri_for('/check') .  '" method="post">'. 
        $c->stash->{recaptcha}.
        ' <br/> <input type="submit" value="submit" /> </form>';

    $c->res->body($body);
} 

sub check : Local {
    my ($self, $c) = @_;
    $c->forward('captcha_check');
    $c->detach('default');
}

1;
