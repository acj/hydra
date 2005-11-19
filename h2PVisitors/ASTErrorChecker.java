/*
 * Created on Sep 30, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package h2PVisitors;

import h2PFoundation.AcceptReturnType;
import h2PNodes.ActionNode;
import h2PNodes.ClassBodyNode;
import h2PNodes.ClassNode;
import h2PNodes.CompositeStateBodyNode;
import h2PNodes.CompositeStateNode;
import h2PNodes.ConcurrentCompositeBodyNode;
import h2PNodes.ConcurrentCompositeNode;
import h2PNodes.DriverFileNode;
import h2PNodes.EventNode;
import h2PNodes.HistoryNode;
import h2PNodes.InitNode;
import h2PNodes.InstanceVariableNode;
import h2PNodes.JoinNode;
import h2PNodes.MessageNode;
import h2PNodes.MessagesNode;
import h2PNodes.ModelBodyNode;
import h2PNodes.ModelNode;
import h2PNodes.NullNode;
import h2PNodes.SignalNode;
import h2PNodes.StateBodyNode;
import h2PNodes.StateNode;
import h2PNodes.TimeInvariantNode;
import h2PNodes.TransitionActionNode;
import h2PNodes.TransitionActionsNode;
import h2PNodes.TransitionBodyNode;
import h2PNodes.TransitionNode;
import h2PNodes.aNode;

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

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitActionNode(h2PNodes.ActionNode)
	 */
	public AcceptReturnType visitActionNode(ActionNode tNode) {
		// TODO Auto-generated method stub
		return super.visitActionNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitClassBodyNode(h2PNodes.ClassBodyNode)
	 */
	public AcceptReturnType visitClassBodyNode(ClassBodyNode tNode) {
		// TODO Auto-generated method stub
		return super.visitClassBodyNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitClassNode(h2PNodes.ClassNode)
	 */
	public AcceptReturnType visitClassNode(ClassNode tNode) {
		// TODO Auto-generated method stub
		return super.visitClassNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitCompositeStateBodyNode(h2PNodes.CompositeStateBodyNode)
	 */
	public AcceptReturnType visitCompositeStateBodyNode(CompositeStateBodyNode tNode) {
		// TODO Auto-generated method stub
		return super.visitCompositeStateBodyNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitCompositeStateNode(h2PNodes.CompositeStateNode)
	 */
	public AcceptReturnType visitCompositeStateNode(CompositeStateNode tNode) {
		// TODO Auto-generated method stub
		return super.visitCompositeStateNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitConcurrentCompositeBodyNode(h2PNodes.ConcurrentCompositeBodyNode)
	 */
	public AcceptReturnType visitConcurrentCompositeBodyNode(ConcurrentCompositeBodyNode tNode) {
		// TODO Auto-generated method stub
		return super.visitConcurrentCompositeBodyNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitConcurrentCompositeNode(h2PNodes.ConcurrentCompositeNode)
	 */
	public AcceptReturnType visitConcurrentCompositeNode(ConcurrentCompositeNode tNode) {
		// TODO Auto-generated method stub
		return super.visitConcurrentCompositeNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitDriverFileNode(h2PNodes.DriverFileNode)
	 */
	public AcceptReturnType visitDriverFileNode(DriverFileNode tNode) {
		// TODO Auto-generated method stub
		return super.visitDriverFileNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitEventNode(h2PNodes.EventNode)
	 */
	public AcceptReturnType visitEventNode(EventNode tNode) {
		// TODO Auto-generated method stub
		return super.visitEventNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitHistoryNode(h2PNodes.HistoryNode)
	 */
	public AcceptReturnType visitHistoryNode(HistoryNode tNode) {
		// TODO Auto-generated method stub
		return super.visitHistoryNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitInitNode(h2PNodes.InitNode)
	 */
	public AcceptReturnType visitInitNode(InitNode tNode) {
		// TODO Auto-generated method stub
		return super.visitInitNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitInstanceVariableNode(h2PNodes.InstanceVariableNode)
	 */
	public AcceptReturnType visitInstanceVariableNode(InstanceVariableNode tNode) {
		// TODO Auto-generated method stub
		return super.visitInstanceVariableNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitJoinNode(h2PNodes.JoinNode)
	 */
	public AcceptReturnType visitJoinNode(JoinNode tNode) {
		// TODO Auto-generated method stub
		return super.visitJoinNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitMessageNode(h2PNodes.MessageNode)
	 */
	public AcceptReturnType visitMessageNode(MessageNode tNode) {
		// TODO Auto-generated method stub
		return super.visitMessageNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitMessagesNode(h2PNodes.MessagesNode)
	 */
	public AcceptReturnType visitMessagesNode(MessagesNode tNode) {
		// TODO Auto-generated method stub
		return super.visitMessagesNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitModelBodyNode(h2PNodes.ModelBodyNode)
	 */
	public AcceptReturnType visitModelBodyNode(ModelBodyNode tNode) {
		// TODO Auto-generated method stub
		return super.visitModelBodyNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitModelNode(h2PNodes.ModelNode)
	 */
	public AcceptReturnType visitModelNode(ModelNode tNode) {
		// TODO Auto-generated method stub
		return super.visitModelNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitNode(h2PNodes.aNode)
	 */
	public AcceptReturnType visitNode(aNode tNode) {
		// TODO Auto-generated method stub
		return super.visitNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitNullNode(h2PNodes.NullNode)
	 */
	public AcceptReturnType visitNullNode(NullNode tNode) {
		// TODO Auto-generated method stub
		return super.visitNullNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitSignalNode(h2PNodes.SignalNode)
	 */
	public AcceptReturnType visitSignalNode(SignalNode tNode) {
		// TODO Auto-generated method stub
		return super.visitSignalNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitStateBodyNode(h2PNodes.StateBodyNode)
	 */
	public AcceptReturnType visitStateBodyNode(StateBodyNode tNode) {
		// TODO Auto-generated method stub
		return super.visitStateBodyNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitStateNode(h2PNodes.StateNode)
	 */
	public AcceptReturnType visitStateNode(StateNode tNode) {
		// TODO Auto-generated method stub
		return super.visitStateNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitTimeInvariantNode(h2PNodes.TimeInvariantNode)
	 */
	public AcceptReturnType visitTimeInvariantNode(TimeInvariantNode tNode) {
		// TODO Auto-generated method stub
		return super.visitTimeInvariantNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitTransitionActionNode(h2PNodes.TransitionActionNode)
	 */
	public AcceptReturnType visitTransitionActionNode(TransitionActionNode tNode) {
		// TODO Auto-generated method stub
		return super.visitTransitionActionNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitTransitionActionsNode(h2PNodes.TransitionActionsNode)
	 */
	public AcceptReturnType visitTransitionActionsNode(TransitionActionsNode tNode) {
		// TODO Auto-generated method stub
		return super.visitTransitionActionsNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitTransitionBodyNode(h2PNodes.TransitionBodyNode)
	 */
	public AcceptReturnType visitTransitionBodyNode(TransitionBodyNode tNode) {
		// TODO Auto-generated method stub
		return super.visitTransitionBodyNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitTransitionNode(h2PNodes.TransitionNode)
	 */
	public AcceptReturnType visitTransitionNode(TransitionNode tNode) {
		// TODO Auto-generated method stub
		return super.visitTransitionNode(tNode);
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