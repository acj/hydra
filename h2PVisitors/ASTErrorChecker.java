/*
 * Created on Sep 30, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package h2PVisitors;

/**
 * @author karli
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ASTErrorChecker extends aVisitor {

	/**
	 * the AST Error Checka!
	 */
	public ASTErrorChecker() {
		super();
		// TODO Auto-generated constructor stub
	}

}

/*

#Called by ASTVisitorForPromela.pm/sub visitstatebodyNode()
sub outputTransitions
{
    my ( $class, $thisvisitor, $outputState, $transeventlist, $mtypelist, $iftarget, $thisstatebodynode ) = @_;

    #head of transitions in this statebodyNode
    #           atomic {if :: !t?[free] -> t!free :: else skip fi;}
    #           if
    @$outputState = visitstatebodyNodePak->TransitionHeadOutput(@$outputState);

    #2, visit @transeventlist and generate the body of transitions in this statebodyNode
    my $event;
    my $transitionlist = '';    #a pointer to an array
    my $newent;
    my $guard;
    my $actions;
    my $messages;
    my $countguard = 0;         #used to count how many guards one event category has
    my @outputTrans;

    #added 04-04-03 To fix non-determinism
    my $iffirst = 0;

    #added 04-04-03
    foreach $ent (@$transeventlist)  {
        $event          = $ent->{event};
        $transitionlist = $ent->{transitionlist};

        #according to different categories output to @outputState
        if ( $event eq 'EMPTYTRANS' )
        {
            @$outputState = visitstatebodyNodePak->EMPTYTRANSoutputState( $thisstatebodynode, $transitionlist, @$outputState );
        } else  {
            if ( $event eq 'NOEVENT' ) {  #push(@$outputState,"        :: atomic{1 -> ");
            } else  {
                $event->Accept($thisvisitor);    #@outputTrans holds the result of this eventNode
                @outputTrans = ASTVisitorForPromela->PassoutputTrans;
                if ( $event->{eventtype} eq 'normal' )
                {
                    my $localret =
                      UniversalClass->FindLocalDestNode( $thisstatebodynode, "SignalNode", $event->{eventname}, "name" );
                    if ( $localret eq '' )
                    {
                        push( @$outputState, "        :: atomic{evt??$event->{eventname},eval(_pid) -> " );
                    } else  {
                        @$outputState = UniversalClass->jointwoarrays( \@outputTrans, $outputState );
                    }
                } else {
                    @$outputState = UniversalClass->jointwoarrays( \@outputTrans, $outputState );
                }
            } /* IF NOEVENT * /

            @$outputState =
              visitstatebodyNodePak->outputINPredicateZero( $iftarget, $thisstatebodynode, @$outputState );
            $countguard = 0;

            $iffirst = 1;

            foreach $newent (@$transitionlist)    #$newent is a TransNode
            {

                ( $countguard, @$outputState ) =
                  visitstatebodyNodePak->outputGuard( $newent->{tran}, $newent->{tran}->{guard},
                                                      $countguard, $event, @$outputState );

                if ( ( $countguard eq 0 ) )
                {                                 #there is no guard at all, so nondeterminism
                    if ( $event eq 'NOEVENT' )
                    {

                        my $statetimeinvariant = ASTVisitorForPromela->GetstatetimeinvariantAndUndef();
                        if ( $statetimeinvariant eq '' )
                        {
                            push( @$outputState, "        :: atomic{1 -> " );
                        } else  {
                            push( @$outputState, "        :: atomic{Timer_V.$statetimeinvariant -> " );
                        }

                    } else {
                        if ( $iffirst ne 1 )
                        {
                            $event->Accept($thisvisitor);    #@outputTrans holds the result of this eventNode
                            @outputTrans = ASTVisitorForPromela->PassoutputTrans;
                            @$outputState = UniversalClass->jointwoarrays( \@outputTrans, $outputState );
                        }
                    }
                } /* If countguard eq 0 * /
                $iffirst = $iffirst + 1;

                @$outputState =
                  visitstatebodyNodePak->outputActionsMsgs( $thisvisitor, 'Actions', $newent->{tran}->{actions},
                                                            $countguard, @$outputState );

                @$outputState =
                  visitstatebodyNodePak->outputActionsMsgs( $thisvisitor, 'Msgs', $newent->{tran}->{messages},
                                                            $countguard, @$outputState );

                @$outputState = visitstatebodyNodePak->output_dest(        $thisstatebodynode, $newent->{dest}, $newent->{desttype},
                                                               $countguard,        $mtypelist,      @$outputState );
            } /* foreach newend * /

            @$outputState =
              visitstatebodyNodePak->output_guardEnd( $countguard, $event, $thisstatebodynode, @$outputState );
        } /* if EmptyTrans * /
    }

    my $tempdest = $thisstatebodynode->{parent}->{ID};
    @$outputState = visitstatebodyNodePak->TransitionEndOutput( $thisstatebodynode, @$outputState );

    return @$outputState;
}

*/