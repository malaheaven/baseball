package com.baseball.dto;

import com.baseball.domain.Match;
import com.baseball.domain.MatchInfo;
import com.baseball.domain.Team;

import java.util.List;

public class MatchInfoDto {

    private final ScoreDto scores;
    private final Integer strike;
    private final Integer ball;
    private final Integer outCount;
    private final List<Boolean> bases;
    private final InningInfoDto inningInfo;
    private final PitcherDto pitcher;
    private final BatterDto batter;
    private final List<Boolean> pitcherInfo;

    private MatchInfoDto(Builder builder) {
        this.scores = builder.scores;
        this.strike = builder.strike;
        this.ball = builder.ball;
        this.outCount = builder.outCount;
        this.bases = builder.bases;
        this.inningInfo = builder.inningInfo;
        this.pitcher = builder.pitcher;
        this.batter = builder.batter;
        this.pitcherInfo = builder.pitcherInfo;
    }

    private static class Builder {
        private ScoreDto scores;
        private Integer strike;
        private Integer ball;
        private Integer outCount;
        private List<Boolean> bases;
        private InningInfoDto inningInfo;
        private PitcherDto pitcher;
        private BatterDto batter;
        private List<Boolean> pitcherInfo;

        private Builder scores(ScoreDto scores) {
            this.scores = scores;
            return this;
        }

        private Builder strike(Integer strike) {
            this.strike = strike;
            return this;
        }

        private Builder ball(Integer ball) {
            this.ball = ball;
            return this;
        }

        private Builder outCount(Integer outCount) {
            this.outCount = outCount;
            return this;
        }

        private Builder bases(List<Boolean> bases) {
            this.bases = bases;
            return this;
        }

        private Builder inningInfo(InningInfoDto inningInfo) {
            this.inningInfo = inningInfo;
            return this;
        }

        private Builder pitcher(PitcherDto pitcher) {
            this.pitcher = pitcher;
            return this;
        }

        private Builder batter(BatterDto batter) {
            this.batter = batter;
            return this;
        }

        private Builder pitcherInfo(List<Boolean> pitcherInfo) {
            this.pitcherInfo = pitcherInfo;
            return this;
        }

        private MatchInfoDto build() {
            return new MatchInfoDto(this);
        }
    }

    public ScoreDto getScores() {
        return scores;
    }

    public Integer getStrike() {
        return strike;
    }

    public Integer getBall() {
        return ball;
    }

    public Integer getOutCount() {
        return outCount;
    }

    public List<Boolean> getBases() {
        return bases;
    }

    public InningInfoDto getInningInfo() {
        return inningInfo;
    }

    public PitcherDto getPitcher() {
        return pitcher;
    }

    public BatterDto getBatter() {
        return batter;
    }

    public List<Boolean> getPitcherInfo() {
        return pitcherInfo;
    }

    public static MatchInfoDto from(Match match) {
        Team awayTeam = match.getAwayTeam();
        Team homeTeam = match.getHomeTeam();
        MatchInfo matchInfo = match.getMatchInfo();
        Builder builder = new Builder()
                .scores(ScoreDto.from(awayTeam, homeTeam))
                .strike(matchInfo.getStrike())
                .ball(matchInfo.getBall())
                .outCount(matchInfo.getOutCount())
                .bases(matchInfo.getBases())
                .inningInfo(InningInfoDto.from(matchInfo))
                .pitcher(PitcherDto.from(match.getPitcher()))
                .batter(BatterDto.from(match.getBatter()))
                .pitcherInfo(matchInfo.getPitcherInfo());
        return builder.build();
    }
}
