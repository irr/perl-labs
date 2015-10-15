 # Note that Lingua::StanfordCoreNLP can't be instantiated.
 use Lingua::StanfordCoreNLP;

 # Create a new NLP pipeline (silence messages, make corefs bidirectional)
 my $pipeline = new Lingua::StanfordCoreNLP::Pipeline();

 # Process text
 # (Will output lots of debug info from the Java classes to STDERR.)
 my $result = $pipeline->process(
    'Jane looked at the IBM computer. She turned it off.'
 );

 my @seen_corefs;

 # Print results
 for my $sentence (@{$result->toArray}) {
    print "\n[Sentence ID: ", $sentence->getIDString, "]:\n";
    print "Original sentence:\n\t", $sentence->getSentence, "\n";

    print "Tagged text:\n";
    for my $token (@{$sentence->getTokens->toArray}) {
       printf "\t%s/%s/%s [%s]\n",
              $token->getWord,
              $token->getPOSTag,
              $token->getNERTag,
              $token->getLemma;
    }

    print "Dependencies:\n";
    for my $dep (@{$sentence->getDependencies->toArray}) {
       printf "\t%s(%s-%d, %s-%d) [%s]\n",
              $dep->getRelation,
              $dep->getGovernor->getWord,
              $dep->getGovernorIndex,
              $dep->getDependent->getWord,
              $dep->getDependentIndex,
              $dep->getLongRelation;
    }

    print "Coreferences:\n";
    for my $coref (@{$sentence->getCoreferences->toArray}) {
       printf "\t%s [%d, %d] <=> %s [%d, %d]\n",
              $coref->getSourceToken->getWord,
              $coref->getSourceSentence,
              $coref->getSourceHead,
              $coref->getTargetToken->getWord,
              $coref->getTargetSentence,
              $coref->getTargetHead;

       print "\t\t(Duplicate)\n"
          if(grep { $_->equals($coref) } @seen_corefs);

       push @seen_corefs, $coref;
    }
 }

