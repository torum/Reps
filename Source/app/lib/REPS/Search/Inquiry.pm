package REPS::Search::Inquiry;

use strict;
use CGI::Carp qw(fatalsToBrowser);

sub new{
    my ($class,$app) = @_;
    my $self = {
        '_app' => $app,
        'MAIL_FROM'=> '',
        'MAIL_TO'=> '',
        'MAIL_CC'=> '',
        'MAIL_BCC'=> '',
        'MAIL_SUBJECT'=> '[reps]',
        'MAIL_TEXT'=> ''
    };

    return bless $self,$class;
}

sub send{
    my $self = shift;
    my $sendmail = $self->{'_app'}->cfg('sendmail_path');

    if (!$sendmail){croak "need sendmail path.";}

    if ($sendmail =~ m|([\w\-\_\/\.]*)|){ #if ($name =~ /^([-\@\w.]+)$/)
        my $sendmail = $1;
    }else{
        croak "insecure sendmail path.";
    }
    $ENV{'PATH'} = '/bin:/usr/bin:/usr/local/bin:/usr/sbin';
    my $output = '';

    require 'jcode.pl';

    if ($self->{'MAIL_TO'} =~ /^[-\w.]+@[-\w.]+\.[-\w]+$/) {
        
    }else {
        $output .= 'メール送信先のアドレスが不正です。';
    }
    if ($self->{'MAIL_FROM'} =~ /^[-\w.]+@[-\w.]+\.[-\w]+$/) {
        
    }else {
        $output .= 'メール送信元のアドレスが不正です。';
    }
    if ($self->{'MAIL_CC'}){
        unless ($self->{'MAIL_CC'} =~ /^[-\w.]+@[-\w.]+\.[-\w]+$/) {
            $output .= 'メールCCのアドレスが不正です。';
        }
    }
    if ($self->{'MAIL_BCC'}){
        unless ($self->{'MAIL_BCC'} =~ /^[-\w.]+@[-\w.]+\.[-\w]+$/) {
            $output .= 'メールBCCのアドレスが不正です。';
        }
    }

    if ($self->{'_app'}->param('this_is_demo')){
        $output .= "デモ版として動いているので、メールは送られません。";
        return $output;
    }

    if ($output){
        return $output;
    }else{

        require REPS::Util;
        #my $subject = REPS::Util->convert2htmlchars(REPS::Util->stripCrLf($self->{'MAIL_SUBJECT'}));
        #my $text = REPS::Util->convert2htmlchars($self->{'MAIL_TEXT'});
        my $subject = REPS::Util->stripCrLf($self->{'MAIL_SUBJECT'});
        my $text = $self->{'MAIL_TEXT'};

        jcode::convert(\$subject, 'jis');
        $subject = &enc_b64($subject);
    
        jcode::convert(\$text, 'jis');
    
        open (SENDMAIL, "|$sendmail -t") || croak "cannot open sendmail.";
        
        print SENDMAIL "From: $self->{'MAIL_FROM'}\n";
        print SENDMAIL "Subject: $subject\n";
        print SENDMAIL "To: $self->{'MAIL_TO'}\n";
        if ($self->{'MAIL_CC'}){
            print SENDMAIL "Cc: $self->{'MAIL_CC'}\n";
        }
        if ($self->{'MAIL_BCC'}){
            print SENDMAIL "Bcc: $self->{'MAIL_BCC'}\n";
        }

        print SENDMAIL "Content-Transfer-Encoding: 7bit\n";
        print SENDMAIL "Content-Type: text/plain;charset=iso-2022-jp\n\n";
        
        #print SENDMAIL "\n";
        print SENDMAIL "$text\n";
        print SENDMAIL "\n";
        close(SENDMAIL);
    
        return 1;
    }
}


sub enc_b64 {

    my($subject) = @_;
    my($str, $padding);
    while ($subject =~ /(.{1,45})/gs) {
        $str .= substr(pack('u', $1), 1);
        chop($str);
    }
    $str =~ tr|` -_|AA-Za-z0-9+/|;
    $padding = (3 - length($subject) % 3) % 3;
    $str =~ s/.{$padding}$/'=' x $padding/e if $padding;
    "=?ISO-2022-JP?B?$str?=";

}

1 
